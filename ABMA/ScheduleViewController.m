//
//  ScheduleViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import "ScheduleViewController.h"
#import "SWRevealViewController.h"
#import "SchedDetailViewController.h"
#import "Event+CoreDataClass.h"
#import "Day+CoreDataClass.h"
#import "Year+CoreDataClass.h"
#import "AppDelegate.h"
#import "Paper+CoreDataClass.h"
#import "Sponsor+CoreDataClass.h"
#import "ABMA-Swift.h"
#import "Note+CoreDataClass.h"
#import "Survey+CoreDataClass.h"
#import "Map+CoreDataClass.h"

@interface ScheduleViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ScheduleViewController
{
    NSArray *events;
    NSArray *days;
    NSInteger dateIndex;
    NSManagedObjectContext *context;
    NSArray *pickerData;
    UIPickerView *picker;
    UIView *actionView;
    UIRefreshControl *refreshControl;
    NSString * selectedYear;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateIndex = 0;
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    
    [self loadSchedule];
    //    [self loadBackendless];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadBackendless) forControlEvents:UIControlEventValueChanged];
    if ([self.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        self.tableView.refreshControl = refreshControl;
    } else {
        [self.tableView addSubview:refreshControl];
    }
    
}

- (void)loadBackendless {
    if (!refreshControl.isRefreshing) {
        [refreshControl beginRefreshing];
    }
    [self.activityIndicator startAnimating];
    [[DbManager sharedInstance] getPublishedYearsSince:[Utils getLastUpdated] callback:^(NSArray<BYear *> * _Nullable years, NSString * _Nullable error) {
        [self.activityIndicator stopAnimating];
        if (error) {
            [Utils handleErrorWithMethod:@"GetPublishedYears" message:error];
            NSLog(@"error: %@", error);
        } else {
            for (BYear *bYear in years) {
                [ScheduleViewController saveBackendlessYear:bYear context:context];
            }
            [self loadSchedule];
        }
    }];
}

- (void)loadBackendlessEvents:(Year *)year {
    if (!refreshControl.isRefreshing) {
        [refreshControl beginRefreshing];
    }
    [self.activityIndicator startAnimating];
    [[DbManager sharedInstance] getEventsWithYearId:year.bObjectId callback:^(NSArray<BEvent *> * _Nullable response, NSString * _Nullable error) {
        if (error) {
            [Utils handleErrorWithMethod:@"GetEvents" message:error];
            NSLog(@"error: %@", error);
        } else {
            [self saveBackendlessEvents:response forYear:year];
            if (refreshControl.isRefreshing) {
                [refreshControl endRefreshing];
            }
            [self.activityIndicator stopAnimating];
        }
    }];
}

- (void)saveBackendlessEvents:(NSArray<BEvent *> *)bEvents forYear:(Year *)year  {
    for (BEvent *bEvent in bEvents) {
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        Day *dayForEvent = nil;
        for (Day *day in year.day) {
            if ([calendar isDate:bEvent.startDate equalToDate:day.date toUnitGranularity:NSCalendarUnitDay]) {
                dayForEvent = day;
                break;
            }
        }
        if (dayForEvent == nil) {
            dayForEvent = [[Day alloc] initWithEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            dayForEvent.date = [ScheduleViewController dateWithOutTime:bEvent.startDate];
            [year addDayObject:dayForEvent];
        }
        
        NSFetchRequest<Event*> *eventRequest = [Event fetchRequest];
        eventRequest.fetchLimit = 1;
        eventRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==%@", bEvent.objectId];
        NSError *eventError = nil;
        Event *thisEvent = [context executeFetchRequest:eventRequest error:&eventError].firstObject;
        if (!thisEvent) {
            thisEvent = [[Event alloc] initWithEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        }
        thisEvent.bObjectId = bEvent.objectId;
        thisEvent.title = bEvent.title;
        thisEvent.subtitle = bEvent.subtitle;
        thisEvent.locatoin = bEvent.location;
        thisEvent.startDate = bEvent.startDate;
        thisEvent.endDate = bEvent.endDate;
        thisEvent.details = bEvent.details;
        thisEvent.created = bEvent.created;
        thisEvent.updated = bEvent.upadted;
        
        if (bEvent.papersCount) {
            [[DbManager sharedInstance] getPapersWithEventId:bEvent.objectId callback:^(NSArray<BPaper *> * _Nullable papers, NSString * _Nullable error) {
                if (error) {
                    [Utils handleErrorWithMethod:@"GetPublishedYears" message:error];
                    NSLog(@"error: %@", error);
                } else {
                    NSMutableOrderedSet *papersSet = [[NSMutableOrderedSet alloc] init];
                    NSArray <BPaper *> *orderedPapers = [papers sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
                    for (BPaper *bPaper in orderedPapers) {
                        
                        NSFetchRequest<Paper*> *paperRequest = [Paper fetchRequest];
                        paperRequest.fetchLimit = 1;
                        paperRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==%@", bPaper.objectId];
                        NSError *paperError = nil;
                        Paper *paper = [context executeFetchRequest:paperRequest error:&paperError].firstObject;
                        if (!paper) {
                            paper = [[Paper alloc] initWithEntity:[NSEntityDescription entityForName:@"Paper" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                        }
                        paper.bObjectId = bPaper.objectId;
                        paper.author = bPaper.author;
                        paper.title = bPaper.title;
                        paper.abstract = bPaper.synopsis;
                        paper.event = thisEvent;
                        paper.created = bPaper.created;
                        paper.updated = bPaper.upadted;
                        [papersSet addObject:paper];
                    }
                    thisEvent.papers = papersSet;
                }
                [dayForEvent addEventObject:thisEvent];
                NSError *saveEror;
                [context save:&saveEror];
                if (saveEror) {
                    NSLog(@"Error: %@", saveEror.localizedDescription);
                }
            }];
        } else {
            [dayForEvent addEventObject:thisEvent];
            NSError *saveEror;
            [context save:&saveEror];
            if (saveEror) {
                NSLog(@"Error: %@", saveEror.localizedDescription);
            }
        }
    }
    [self loadSchedule];
}

+ (void)saveBackendlessYear:(BYear *)bYear context:(NSManagedObjectContext *)context {
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"MMM d, yyyy"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dayFormatter setTimeZone:timeZone];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"MMM d, yyyy h:mma"];
    
    NSFetchRequest<Year*> *yearRequest = [Year fetchRequest];
    yearRequest.fetchLimit = 1;
    yearRequest.predicate = [NSPredicate predicateWithFormat:@"year==%ld", (long)bYear.name];
    yearRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO]];
    NSError *error = nil;
    Year *year = [context executeFetchRequest:yearRequest error:&error].firstObject;
    
    if (!year) {
        year = [[Year alloc] initWithEntity:[NSEntityDescription entityForName:@"Year" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    }
    
    year.bObjectId = bYear.objectId;
    year.year = [NSString stringWithFormat:@"%ld", (long)bYear.name] ;
    year.info = bYear.info;
    year.welcome = bYear.welcome;
    year.created = bYear.created;
    year.updated = bYear.updated;
    if (year.updated) {
        [Utils updateLastUpdatedWithDate:year.updated];
    } else {
        [Utils updateLastUpdatedWithDate:year.created];
    }
    
    for (Survey *survey in year.surveys) {
        [context deleteObject:survey];
    }
    NSArray<BSurvey *> *bSurveys = [Utils getSurveysWithSurveysString:bYear.surveys];
    for (BSurvey *bSurvey in bSurveys) {
        Survey *survey = [[Survey alloc] initWithEntity:[NSEntityDescription entityForName:@"Survey" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        survey.title = bSurvey.title;
        survey.details = bSurvey.details;
        survey.url = bSurvey.url;
        survey.start = bSurvey.start;
        survey.end = bSurvey.end;
        [year addSurveysObject:survey];
    }
    
    for (Map *map in year.maps) {
        [context deleteObject:map];
    }
    NSArray<BMap *> *bMaps = [Utils getMapssWithMapsString:bYear.maps];
    for (BMap *bMap in bMaps) {
        Map *map = [[Map alloc] initWithEntity:[NSEntityDescription entityForName:@"Map" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        map.title = bMap.title;
        map.url = bMap.url;
        [year addMapsObject:map];
    }
    
    for (BSponsor *bSponsor in bYear.sponsors) {
        
        NSFetchRequest<Sponsor*> *sponsorRequest = [Sponsor fetchRequest];
        sponsorRequest.fetchLimit = 1;
        sponsorRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==%@", bSponsor.objectId];
        NSError *sponsorError = nil;
        Sponsor *sponsor = [context executeFetchRequest:sponsorRequest error:&sponsorError].firstObject;
        if (!sponsor) {
            sponsor = [[Sponsor alloc] initWithEntity:[NSEntityDescription entityForName:@"Sponsor" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        }
        sponsor.bObjectId = bSponsor.objectId;
        sponsor.url = bSponsor.url;
        sponsor.imageUrl = bSponsor.imageUrl;
        sponsor.year = year;
        sponsor.created = bSponsor.created;
        sponsor.updated = bSponsor.upadted;
        [year addSponsorsObject:sponsor];
    }
    
    for (BEvent *bEvent in bYear.events) {
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        Day *dayForEvent = nil;
        for (Day *day in year.day) {
            if ([calendar isDate:bEvent.startDate equalToDate:day.date toUnitGranularity:NSCalendarUnitDay]) {
                dayForEvent = day;
                break;
            }
        }
        if (dayForEvent == nil) {
            dayForEvent = [[Day alloc] initWithEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            dayForEvent.date = [self dateWithOutTime:bEvent.startDate];
            [year addDayObject:dayForEvent];
        }
        
        NSFetchRequest<Event*> *eventRequest = [Event fetchRequest];
        eventRequest.fetchLimit = 1;
        eventRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==%@", bEvent.objectId];
        NSError *eventError = nil;
        Event *thisEvent = [context executeFetchRequest:eventRequest error:&eventError].firstObject;
        if (!thisEvent) {
            thisEvent = [[Event alloc] initWithEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        }
        thisEvent.bObjectId = bEvent.objectId;
        thisEvent.title = bEvent.title;
        thisEvent.subtitle = bEvent.subtitle;
        thisEvent.locatoin = bEvent.location;
        thisEvent.startDate = bEvent.startDate;
        thisEvent.endDate = bEvent.endDate;
        thisEvent.details = bEvent.details;
        thisEvent.created = bEvent.created;
        thisEvent.updated = bEvent.upadted;
        NSMutableOrderedSet *papersSet = [[NSMutableOrderedSet alloc] init];
        NSArray <BPaper *> *orderedPapers = [bEvent.papers sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
        for (BPaper *bPaper in orderedPapers) {
            
            NSFetchRequest<Paper*> *paperRequest = [Paper fetchRequest];
            paperRequest.fetchLimit = 1;
            paperRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==%@", bPaper.objectId];
            NSError *paperError = nil;
            Paper *paper = [context executeFetchRequest:paperRequest error:&paperError].firstObject;
            if (!paper) {
                paper = [[Paper alloc] initWithEntity:[NSEntityDescription entityForName:@"Paper" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            }
            paper.bObjectId = bPaper.objectId;
            paper.author = bPaper.author;
            paper.title = bPaper.title;
            paper.abstract = bPaper.synopsis;
            paper.event = thisEvent;
            paper.created = bPaper.created;
            paper.updated = bPaper.upadted;
            [papersSet addObject:paper];
        }
        thisEvent.papers = papersSet;
        [dayForEvent addEventObject:thisEvent];
    }
    NSError *saveEror;
    [context save:&saveEror];
    if (saveEror) {
        NSLog(@"Error: %@", saveEror.localizedDescription);
    }
}

+ (NSDate *)dateWithOutTime:(NSDate *)datDate {
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (void)loadSchedule {
    
    Year *year = [Year getLatestYear:selectedYear context:context];
    
    if (year) {
        if (year.day && year.day.count) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];
            days = [[year.day allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            [self loadDay:0];
        } else {
            [self loadBackendlessEvents:year];
        }
    } else {
        [self loadBackendless];
    }
    NSString *currentBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    [[NSUserDefaults standardUserDefaults] setObject:currentBuild forKey:@"build"];
}

- (void)loadDay: (NSUInteger)index {
    Day *thisDay = days[index];
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"MMM d, yyyy"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dayFormatter setTimeZone:timeZone];
    
    self.dateLabe.text = [dayFormatter stringFromDate:thisDay.date];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES], nil];
    events = [thisDay.event sortedArrayUsingDescriptors:sortDescriptors];
    if (refreshControl.isRefreshing) {
        [refreshControl endRefreshing];
    }
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

- (void)saveSchedule {
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"MMM d, yyyy"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dayFormatter setTimeZone:timeZone];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"MMM d, yyyy h:mma"];
    [timeFormatter setTimeZone:timeZone];
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"Y2016" ofType:@"plist"];
    NSDictionary *dailySched = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    NSArray *allKeys = [dailySched allKeys];
    
    Year *year = [[Year alloc] initWithEntity:[NSEntityDescription entityForName:@"Year" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    for (NSString *key in allKeys) {
        Day *day = [[Day alloc] initWithEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        day.date = [dayFormatter dateFromString:key];
        NSArray *eventsArray = [[NSArray alloc] initWithArray:[dailySched objectForKey:key]];
        for (NSDictionary *event in eventsArray) {
            Event *thisEvent = [[Event alloc] initWithEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            thisEvent.title = [event objectForKey:@"Title"];
            thisEvent.subtitle = [event objectForKey:@"Subtitle"];
            thisEvent.locatoin = [event objectForKey:@"Location"];
            NSString *time = [event objectForKey:@"Time"];
            NSArray *times = [time componentsSeparatedByString:@" - "];
            if (times.count == 0) {
                NSLog(@"No times for %@", time);
            }
            NSString *startString = [NSString stringWithFormat:@"%@ %@", key, [times firstObject]];
            thisEvent.startDate = [timeFormatter dateFromString:startString];
            if (thisEvent.startDate == nil) {
                NSLog(@"startDate did't format for %@", startString);
            }
            NSString *endString = [NSString stringWithFormat:@"%@ %@", key, [times lastObject]];
            if (times.count == 2) {
                thisEvent.endDate = [timeFormatter dateFromString:endString];
            }
            thisEvent.details = [event objectForKey:@"Description"];
            NSArray *papers = [event objectForKey:@"Papers"];
            for (NSDictionary *paperDict in papers) {
                Paper *paper = [[Paper alloc] initWithEntity:[NSEntityDescription entityForName:@"Paper" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                paper.author = [paperDict objectForKey:@"Author"];
                paper.title = [paperDict objectForKey:@"Title"];
                paper.abstract = [paperDict objectForKey:@"Abstract"];
                paper.event = thisEvent;
            }
            [day addEventObject:thisEvent];
        }
        [year addDayObject:day];
    }
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    } else {
        [self loadSchedule];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UILabel *eventName = (UILabel *)[cell viewWithTag:101];
    UILabel *eventTime = (UILabel *)[cell viewWithTag:102];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Event *thisEvent = [events objectAtIndex:indexPath.row];
    
    eventName.text = thisEvent.title;
    eventTime.text = [Utils timeFrameWithStartDate:thisEvent.startDate endDate:thisEvent.endDate];
    return cell;
}


#pragma mark - Picker

- (IBAction)showYearSelection:(id)sender {
    NSFetchRequest<Year*> *yearRequest = [Year fetchRequest];
    yearRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId!=nil"];
    yearRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO]];
    NSError *error = nil;
    NSArray<Year *> *years = [context executeFetchRequest:yearRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {
        if (years.count) {
            NSMutableArray<NSString *> *yearNames = [[NSMutableArray alloc] init];
            for (Year *year in years) {
                NSLog(@"Year name = %@", year.year);
                [yearNames addObject:year.year];
            }
            [self showPicker:yearNames];
        }
    }
}


- (void)showPicker:(NSArray *)names {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    picker = [[UIPickerView alloc] init];
    picker.frame = CGRectMake(0.0, 44.0, width, 216.0);
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = true;
    picker.backgroundColor = [UIColor whiteColor];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlack;
    pickerDateToolbar.barTintColor = [UIColor blackColor];
    pickerDateToolbar.translucent = true;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *titleCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPickerSelectionButtonClicked:)];
    [barItems addObject:titleCancel];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject: flexSpace];
    
    pickerData = names;
    [picker selectRow:1 inComponent:0 animated:false];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(countryDoneClicked:)];
    [barItems addObject: doneBtn];
    
    [pickerDateToolbar setItems:barItems animated:true];
    
    actionView = [[UIView alloc] init];
    actionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 260.0);

    
    [actionView addSubview:pickerDateToolbar];
    [actionView addSubview:picker];
    
    [self.view addSubview:actionView];
    
    [UIView animateWithDuration:0.2 animations:^{
        actionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260.0, [UIScreen mainScreen].bounds.size.width, 260.0);
    }];
}

- (void)cancelPickerSelectionButtonClicked:(UIBarButtonItem*)sender {
    [self dismissPicker];
}

- (void)countryDoneClicked:(UIBarButtonItem*)sender {
    
    NSInteger myRow = [picker selectedRowInComponent:0];
    selectedYear = [pickerData objectAtIndex:myRow];
    NSLog(@"Selected %@", selectedYear);
    [self loadSchedule];
    
    [self dismissPicker];
}

- (void)dismissPicker {
    [UIView animateWithDuration:0.2 animations:^{
        actionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 260.0);
    } completion:^(BOOL finished) {
        for (UIView *subview in actionView.subviews) {
            [subview removeFromSuperview];
        }
    }];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerData.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerData objectAtIndex:row];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Event *selectedEvent = events[indexPath.row];
        SchedDetailViewController* dvc = segue.destinationViewController;
        dvc.event = selectedEvent;
    }
}


- (IBAction)earlierDate:(id)sender {
    if (dateIndex == 0) {
        dateIndex = [days count]-1;
    } else {
        dateIndex = dateIndex - 1;
    }
    [self loadDay:dateIndex];
}

- (IBAction)laterDate:(id)sender {
    if (dateIndex == [days count]-1) {
        dateIndex = 0;
    } else {
        dateIndex = dateIndex + 1;
    }
    [self loadDay:dateIndex];
}
@end
