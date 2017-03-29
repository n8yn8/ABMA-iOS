//
//  ScheduleViewController.h
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABMA-Swift.h"

@interface ScheduleViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)earlierDate:(id)sender;
- (IBAction)laterDate:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *dateLabe;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (void)saveBackendlessYear:(BYear *)bYear context:(NSManagedObjectContext *)context;

@end
