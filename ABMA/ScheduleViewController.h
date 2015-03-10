//
//  ScheduleViewController.h
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)earlierDate:(id)sender;
- (IBAction)laterDate:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *dateLabe;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
