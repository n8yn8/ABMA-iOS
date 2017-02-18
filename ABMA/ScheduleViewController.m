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

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController
{
    NSArray *events;
    NSArray *days;
    NSInteger dateIndex;
    NSManagedObjectContext *context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

-(void)loadData
{
    dateIndex = 0;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    
//    [self clearSchedule:@"Day"];
//    [self clearSchedule:@"Event"];
//    [self clearSchedule:@"Note"];
//    [self clearSchedule:@"Paper"];
//    [self loadSchedule];
    [self loadBackendless];
}

- (void)loadBackendless {
    [[DbManager sharedInstance] getYearsWithCallback:^(NSArray<BYear *> * _Nullable years, NSString * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            for (BYear *bYear in years) {
                [self saveBackendlessYear:bYear];
            }
        }
    }];
}

- (void)saveBackendlessYear:(BYear *)bYear {
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"MMM d, yyyy"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dayFormatter setTimeZone:timeZone];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"MMM d, yyyy h:mma"];
    
    Year *year = [[Year alloc] initWithEntity:[NSEntityDescription entityForName:@"Year" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    year.bObjectId = bYear.objectId;
    year.info = bYear.info;
    year.welcome = bYear.welcome;
    for (BSponsor *bSponsor in bYear.sponsors) {
        Sponsor *sponsor = [[Sponsor alloc] initWithEntity:[NSEntityDescription entityForName:@"Sponsor" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        sponsor.bObjectId = bSponsor.objectId;
        sponsor.url = bSponsor.url;
        sponsor.imageUrl = bSponsor.imageUrl;
        sponsor.year = year;
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
        
        Event *thisEvent = [[Event alloc] initWithEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        thisEvent.bObjectId = bEvent.objectId;
        thisEvent.title = bEvent.title;
        thisEvent.subtitle = bEvent.subtitle;
        thisEvent.locatoin = bEvent.location;
        thisEvent.startDate = bEvent.startDate;
        thisEvent.endDate = bEvent.endDate;
        thisEvent.details = bEvent.details;
        for (BPaper *bPaper in bEvent.papers) {
            Paper *paper = [[Paper alloc] initWithEntity:[NSEntityDescription entityForName:@"Paper" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            paper.bObjectId = bPaper.objectId;
            paper.author = bPaper.author;
            paper.title = bPaper.title;
            paper.abstract = bPaper.abstract;
            paper.event = thisEvent;
            [thisEvent addPapersObject:paper];
        }
        [dayForEvent addEventObject:thisEvent];
    }
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    } else {
        [self loadSchedule];
    }
}

-(NSDate *)dateWithOutTime:(NSDate *)datDate {
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (void)clearSchedule:(NSString *)nameEntity {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }
    
    error = nil;
    [context save:&error];
}

- (void)loadSchedule {
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"MMM d, yyyy"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dayFormatter setTimeZone:timeZone];
    
//    NSDate *schedStart = [dayFormatter dateFromString:@"April 17, 2016"];
//    NSDate *schedEnd = [dayFormatter dateFromString:@"April 23, 2016"];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:context]];
    fetchRequest.sortDescriptors = sortDescriptors;
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)",schedStart, schedEnd];
    NSError *fetchError = nil;
    days = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&fetchError]];
    if (fetchError) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    } else {
        if (days.count) {
//            NSString *build = [[NSUserDefaults standardUserDefaults] stringForKey:@"build"];
//            if (!build) {
//                [self fixBuildEighteen];
//            }
            [self loadDay: 0];

        } else {
            [self saveSchedule];
        }
        NSString *currentBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        [[NSUserDefaults standardUserDefaults] setObject:currentBuild forKey:@"build"];
    }
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
            thisEvent.time = [event objectForKey:@"Time"];
            NSArray *times = [thisEvent.time componentsSeparatedByString:@" - "];
            if (times.count == 0) {
                NSLog(@"No times for %@", thisEvent.time);
            }
            NSString *startString = [NSString stringWithFormat:@"%@ %@", key, [times firstObject]];
            thisEvent.startDate = [timeFormatter dateFromString:startString];
            if (thisEvent.startDate == nil) {
                NSLog(@"startDate did't format for %@", startString);
            }
            NSString *endString = [NSString stringWithFormat:@"%@ %@", key, [times lastObject]];
            thisEvent.endDate = [timeFormatter dateFromString:endString];
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

- (void)fixBuildEighteen {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"startDate == NULL"];
    NSError *fetchError = nil;
    NSArray *updateEvents = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&fetchError]];
    if (fetchError) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    } else {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"MMM d, yyyy h:mma"];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        for (Event *thisEvent in updateEvents) {
            thisEvent.time = @"3:00pm - 3:20pm";
            NSArray *times = [thisEvent.time componentsSeparatedByString:@" - "];
            if (times.count == 0) {
                NSLog(@"No times for %@", thisEvent.time);
            }
            NSString *startString = [NSString stringWithFormat:@"April 22, 2016 %@", [times firstObject]];
            thisEvent.startDate = [timeFormatter dateFromString:startString];
            if (thisEvent.startDate == nil) {
                NSLog(@"startDate did't format for %@", startString);
            }
            NSString *endString = [NSString stringWithFormat:@"April 22, 2016 %@", [times lastObject]];
            thisEvent.endDate = [timeFormatter dateFromString:endString];
        }
        NSError *error;
        [context save:&error];
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
    eventTime.text = thisEvent.time;
    return cell;
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
