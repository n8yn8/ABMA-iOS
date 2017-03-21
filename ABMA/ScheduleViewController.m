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

@interface ScheduleViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

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
    
    
    [self loadSchedule];
    [self loadBackendless];
}

- (void)matchNotes {
    NSFetchRequest <Note *> *noteRequst = [Note fetchRequest];
    NSError *error = nil;
    NSArray<Note *> *notes = [context executeFetchRequest:noteRequst error:&error];
    for (Note *note in notes) {
        if (note.paper) {
            if (note.paper.bObjectId) {
                NSLog(@"Already found paper");
            } else {
                NSFetchRequest *paperRequest = [Paper fetchRequest];
                paperRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId!=nil AND title==%@ AND abstract==%@", note.paper.title, note.paper.abstract];
                NSError *error;
                NSArray *papers = [context executeFetchRequest:paperRequest error:&error];
                NSLog(@"Found %lu papers", (unsigned long)papers.count);
                note.paper = [papers firstObject];
            }
        }
        if (note.event) {
            if (note.event.bObjectId) {
                NSLog(@"Already found event");
            } else {
                NSFetchRequest *eventRequest = [Event fetchRequest];
                eventRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId!=nil AND title==%@ AND details==%@", note.event.title, note.event.details];
                NSError *error;
                NSArray *retrieved = [context executeFetchRequest:eventRequest error:&error];
                NSLog(@"Found %lu events", (unsigned long)retrieved.count);
                note.event = [retrieved firstObject];
            }
        }
    }
    NSError *saveError;
    [context save:&saveError];
    
    [self clearSchedule];
}

- (void)loadBackendless {
    [self.activityIndicator startAnimating];
    [[DbManager sharedInstance] getPublishedYearsSince:[Utils getLastUpdated] callback:^(NSArray<BYear *> * _Nullable years, NSString * _Nullable error) {
        [self.activityIndicator stopAnimating];
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            for (BYear *bYear in years) {
                [ScheduleViewController saveBackendlessYear:bYear context:context];
            }
            [self loadSchedule];
            [self matchNotes];
        }
    }];
}

+ (void)saveBackendlessYear:(BYear *)bYear context:(NSManagedObjectContext *)context {
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"MMM d, yyyy"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dayFormatter setTimeZone:timeZone];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"MMM d, yyyy h:mma"];
    
    Year *year = [[Year alloc] initWithEntity:[NSEntityDescription entityForName:@"Year" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    year.bObjectId = bYear.objectId;
    year.year = [NSString stringWithFormat:@"%d", bYear.name] ;
    year.info = bYear.info;
    year.welcome = bYear.welcome;
    year.created = bYear.created;
    year.updated = bYear.updated;
    if (year.updated) {
        [Utils updateLastUpdatedWithDate:year.updated];
    } else {
        [Utils updateLastUpdatedWithDate:year.created];
    }
    for (BSponsor *bSponsor in bYear.sponsors) {
        Sponsor *sponsor = [[Sponsor alloc] initWithEntity:[NSEntityDescription entityForName:@"Sponsor" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
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
        
        Event *thisEvent = [[Event alloc] initWithEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
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
        for (BPaper *bPaper in bEvent.papers) {
            Paper *paper = [[Paper alloc] initWithEntity:[NSEntityDescription entityForName:@"Paper" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
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
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
}

+ (NSDate *)dateWithOutTime:(NSDate *)datDate {
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (void)clearSchedule {
    NSFetchRequest *fetchRequest = [Year fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==nil"];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray<Year *> *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Year *year in fetchedObjects)
    {
        for (Day *day in year.day) {
            for (Event *event in day.event) {
                for (Paper *paper in event.papers) {
                    [context deleteObject:paper];
                }
                [context deleteObject:event];
            }
            [context deleteObject:day];
        }
        [context deleteObject:year];
    }
    
    error = nil;
    [context save:&error];
}

- (void)loadSchedule {
    
    NSFetchRequest<Year*> *yearRequest = [Year fetchRequest];
    yearRequest.fetchLimit = 1;
    yearRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId!=nil"];
    yearRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO]];
    NSError *error = nil;
    Year *year = [context executeFetchRequest:yearRequest error:&error].firstObject;
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {
        if (year) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];
            
            days = [[year.day allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            [self loadDay:0];
        } else {
            [self loadBackendless];
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

- (void)saveScheduleToServer:(int)yearName {
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"MMM d, yyyy"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dayFormatter setTimeZone:timeZone];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"MMM d, yyyy h:mma"];
    [timeFormatter setTimeZone:timeZone];
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Y%i", yearName] ofType:@"plist"];
    NSDictionary *dailySched = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    NSArray *allKeys = [dailySched allKeys];
    
    BYear *year = [[BYear alloc] init];
    year.name = yearName;
    NSMutableArray<BEvent *> *eventsForBYear = [[NSMutableArray alloc] init];
    for (NSString *key in allKeys) {
        NSArray *eventsArray = [[NSArray alloc] initWithArray:[dailySched objectForKey:key]];
        for (NSDictionary *event in eventsArray) {
            BEvent *thisEvent = [[BEvent alloc] init];
            thisEvent.title = [event objectForKey:@"Title"];
            thisEvent.subtitle = [event objectForKey:@"Subtitle"];
            thisEvent.location = [event objectForKey:@"Location"];
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
            NSMutableArray<BPaper*> *eventPapers = [[NSMutableArray alloc] initWithCapacity:papers.count];
            for (NSDictionary *paperDict in papers) {
                BPaper *paper = [[BPaper alloc] init];
                paper.author = [paperDict objectForKey:@"Author"];
                paper.title = [paperDict objectForKey:@"Title"];
                paper.synopsis = [paperDict objectForKey:@"Abstract"];
                [eventPapers addObject:paper];
            }
            thisEvent.papers = eventPapers;
            [eventsForBYear addObject:thisEvent];
        }
        
    }
    year.events = eventsForBYear;
    
    [self saveSponsorsCompletion:^(NSMutableArray<BSponsor *> *sponsors) {
        year.sponsors = sponsors;
        [[DbManager sharedInstance] updateWithYear:year callback:^(BYear * _Nullable save, NSString * _Nullable error) {
            NSLog(@"error %@", error);
            NSLog(@"saved year %@", save);
        }];
    }];
    
}

- (void)saveSponsorsCompletion:(void(^)(NSMutableArray<BSponsor*>* sponsors)) completion {
    NSArray *sponsorImages = [[NSArray alloc] initWithObjects:
                              @"brevard_zoo_logo_m.jpg",
                              @"CFZ.jpg",
                              @"Zoo_Logo.jpg",
                              @"sante_fe_teaching_zoo.png",
                              @"CMA.png",
                              @"fl aq logo.jpg",
                              @"SWO Logo.jpg",
                              @"NEI.png",
                              @"PB.png",
                              @"ABI Logo.jpg",
                              @"BGT Logo.png",
                              @"FAZA.png",
                              @"TAMPA BAY AAZK.png",  nil];
    NSArray *links = [[NSArray alloc] initWithObjects:
                      @"http://www.brevardzoo.org/",
                      @"http://www.centralfloridazoo.org/",
                      @"http://www.lowryparkzoo.org/",
                      @"http://www.sfcollege.edu/zoo/",
                      @"http://www.seewinter.com/",
                      @"http://www.flaquarium.org/",
                      @"https://seaworldparks.com/seaworld-orlando?&gclid=CNnZ_rOg5ssCFUQbgQodW_gLyg&dclid=CMvQhLSg5ssCFUQFgQod384IRQ",
                      @"http://naturalencounters.com/",
                      @"http://www.precisionbehavior.com/",
                      @"http://www.animaledu.com/Home/d/1",
                      @"https://seaworldparks.com/en/buschgardens-tampa/?&gclid=CM7sh5ig5ssCFYclgQodFi4MFg&dclid=CLD5i5ig5ssCFQsNgQodm1IJ_g",
                      @"http://www.flaza.org/zoos--aquariums.html",
                      @"http://tampabayaazk.weebly.com/",
                      nil];
    NSMutableArray<BSponsor *> *sponsors = [[NSMutableArray alloc] initWithCapacity:sponsorImages.count];
    for (int i = 0; i < sponsorImages.count; i++) {
        UIImage *image = [UIImage imageNamed:sponsorImages[i]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [[DbManager sharedInstance] uploadImageWithName:[sponsorImages[i] stringByReplacingOccurrencesOfString:@" " withString:@""] image:imageData callback:^(NSString * _Nonnull imageUrl) {
            BSponsor *sponsor = [[BSponsor alloc] init];
            sponsor.url = links[i];
            sponsor.imageUrl = imageUrl;
            [sponsors addObject:sponsor];
            if (sponsors.count == sponsorImages.count) {
                completion(sponsors);
            }
        }];
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
