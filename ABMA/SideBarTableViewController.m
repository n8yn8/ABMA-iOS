//
//  SideBarTableViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import "SideBarTableViewController.h"
#import "SWRevealViewController.h"
#import "ABMA-Swift.h"
#import "InfoViewController.h"
#import "Year+CoreDataClass.h"
#import "AppDelegate.h"

@interface SideBarTableViewController ()
@property (nonatomic, strong) NSMutableArray *menuItems;
@end

@implementation SideBarTableViewController {
    NSString *surveyUrl;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuItems = [[NSMutableArray alloc] initWithArray:@[@"logo", @"welcome", @"schedule", @"notes", @"info", @"sponsor", @"contact"]];
    
    BOOL isSurveyAvailable = false;
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    Year *year = [Year getLatestYear:nil context:context];
    if (year) {
        if (year.surveyLink) {
            surveyUrl = year.surveyLink;
            NSDate *now = [[NSDate alloc] init];
            if (now.timeIntervalSince1970 > year.surveyStart.timeIntervalSince1970 && now.timeIntervalSince1970 < year.surveyEnd.timeIntervalSince1970) {
                isSurveyAvailable = true;
            }
        }
    }
    if (isSurveyAvailable) {
        [_menuItems addObject:@"survey"];
    }
    
    BackendlessUser *user = [[DbManager sharedInstance] getCurrentUser];
    if (user) {
        [_menuItems addObject:@"logout"];
    }
    
    self.tableView.estimatedRowHeight = 22;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[_menuItems objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"logout"]) {
        [[DbManager sharedInstance] logoutWithCallback:^(NSString * _Nullable error) {
            [_menuItems removeObject:@"logout"];
            [self.tableView reloadData];
        }];
    } else if ([cell.reuseIdentifier isEqualToString:@"survey"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: surveyUrl]];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *child = (UINavigationController *) segue.destinationViewController.childViewControllers[0];
        if ([child isKindOfClass:[InfoViewController class]]) {
            InfoViewController *dvc = (InfoViewController *)child;
            NSString *item = [self.menuItems objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            if ([item isEqualToString:@"welcome"]) {
                dvc.mode = Welcome;
            } else if ([item isEqualToString:@"info"]) {
                dvc.mode = Info;
            }
        }
    }
}

@end
