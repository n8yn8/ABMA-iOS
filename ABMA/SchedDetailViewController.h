//
//  SchedDetailViewController.h
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchedDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventSubtitle;
@property (strong, nonatomic) IBOutlet UILabel *eventLocation;
@property (strong, nonatomic) IBOutlet UILabel *eventTime;
@property (strong, nonatomic) IBOutlet UITextView *eventDetails;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *eventDay;
@property (strong, nonatomic) IBOutlet UILabel *eventDate;
@property (strong, nonatomic) NSDictionary *detailItem;
@property (strong, nonatomic) NSString *detailDay;
@property (strong, nonatomic) NSString *detailDate;
@property (weak, nonatomic) IBOutlet UITextView *noteTextField;

- (IBAction)saveNote:(id)sender;
-(void)setDetailItem:(NSDictionary *)newDetailItem onDay:(NSString *)newDayOfWeek onDate:(NSString *)newDateOfWeek;
@end
