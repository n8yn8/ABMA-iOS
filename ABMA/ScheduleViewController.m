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
#import "Event.h"
#import "Day.h"
#import "Year.h"
#import "AppDelegate.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController
{
    NSDictionary *dailySched;
    NSArray *events;
    NSArray *dates;
    NSArray *daysOfWeek;
    NSArray *numbsOfWeek;
    NSInteger dateIndex;
    NSDateFormatter *format;
    //NSDate *selectedDate;
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
    [self loadGraphics];
    [self loadGestures];
    [self loadData];
    
    format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterNoStyle];
    //selectedDate = [NSDate date];
}

-(void)loadData
{
    dates = [[NSArray alloc] initWithObjects:@"Apr 12, 2014", @"Apr 13, 2014", @"Apr 14, 2014", @"Apr 15, 2014", @"Apr 16, 2014", @"Apr 17, 2014", @"Apr 18, 2014", @"Apr 19, 2014", nil];
    daysOfWeek = [[NSArray alloc] initWithObjects:@"SATURDAY", @"SUNDAY", @"MONDAY", @"TUESDAY", @"WEDNESDAY", @"THURSDAY", @"FRIDAY", @"SATURDAY", nil];
    numbsOfWeek = [[NSArray alloc] initWithObjects:@"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", nil];
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"EventList" ofType:@"plist"];
    dailySched = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    NSArray *allKeys = [dailySched allKeys];
//    for (NSString *key in allKeys) {
//        events = [[NSArray alloc] initWithArray:[dailySched objectForKey:key]];
//    }
    dateIndex = 0;
    //[self loadThisDate:dateIndex];
    
    
    //CoreData
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    NSError *fetchError = nil;
    events = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&fetchError]];
    if (fetchError) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    } else {
        NSLog(@"results = %@", events);
        if (events.count) {
            //TODO: display results
            [self.tableView reloadData];
        } else {
            [self saveSchedule: context];
        }
    }
    

}

- (void)saveSchedule:(NSManagedObjectContext *)context {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy h:mma"];
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"EventList" ofType:@"plist"];
    dailySched = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    NSArray *allKeys = [dailySched allKeys];
    
    Year *year = [[Year alloc] initWithEntity:[NSEntityDescription entityForName:@"Year" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    for (NSString *key in allKeys) {
        Day *day = [[Day alloc] initWithEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        events = [[NSArray alloc] initWithArray:[dailySched objectForKey:key]];
        for (NSDictionary *event in events) {
            Event *thisEvent = [[Event alloc] initWithEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            thisEvent.title = [event objectForKey:@"Title"];
            thisEvent.subtitle = [event objectForKey:@"Subtitle"];
            thisEvent.locatoin = [event objectForKey:@"Location"];
            thisEvent.time = [event objectForKey:@"Time"];
            NSArray *times = [thisEvent.time componentsSeparatedByString:@" - "];
            NSString *startString = [NSString stringWithFormat:@"%@ %@", key, [times firstObject]];
            thisEvent.startDate = [formatter dateFromString:startString];
            NSString *endString = [NSString stringWithFormat:@"%@ %@", key, [times lastObject]];
            thisEvent.endDate = [formatter dateFromString:endString];
            thisEvent.details = [event objectForKey:@"Description"];
            [day addEventObject:thisEvent];
        }
        [year addDayObject:day];
    }
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
}

- (void)loadThisDate:(NSUInteger)index
{
    NSString *date = [dates objectAtIndex:index];
    _dateLabe.text = date;
    events = [[NSArray alloc] initWithArray:[dailySched objectForKey:date]];
    [_tableView reloadData];
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)loadGestures
{
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)loadGraphics
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ABMAlogo.png"]];
    UIColor *bg= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG.png"]];
    self.view.backgroundColor = bg;
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
        NSDictionary *object = events[indexPath.row];
        [[segue destinationViewController] setDetailItem:object onDay:[daysOfWeek objectAtIndex:dateIndex] onDate:[numbsOfWeek objectAtIndex:dateIndex]];
    }
}


- (IBAction)earlierDate:(id)sender {
    if (dateIndex == 0) {
        dateIndex = 7;
    } else {
        dateIndex = dateIndex - 1;
    }
    [self loadThisDate:dateIndex];
}

- (IBAction)laterDate:(id)sender {
    if (dateIndex == 7) {
        dateIndex = 0;
    } else {
        dateIndex = dateIndex + 1;
    }
    [self loadThisDate:dateIndex];
}
@end
