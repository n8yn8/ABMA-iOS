//
//  SchedDetailViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import "SchedDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Note.h"

@interface SchedDetailViewController ()

@end

@implementation SchedDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Managing the detail item

- (IBAction)saveNote:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    NSError *error;
    [context save:&error];
    //TODO: error handling
}

- (void)setDetailItem:(NSDictionary *)newDetailItem onDay:(NSString *)newDayOfWeek onDate:(NSString *)newDateOfWeek
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
    if (_detailDay != newDayOfWeek) {
        _detailDay = newDayOfWeek;
    }
    if (_detailDate != newDateOfWeek) {
        _detailDate = newDateOfWeek;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventDay.text = self.detailDay;
    self.eventDate.text = self.detailDate;
    self.eventTitle.text = [self.detailItem objectForKey:@"Title"];
    self.eventSubtitle.text = [self.detailItem objectForKey:@"Subtitle"];
    self.eventLocation.text = [self.detailItem objectForKey:@"Location"];
    self.eventTime.text = [self.detailItem objectForKey:@"Time"];
    self.eventDetails.text = [self.detailItem objectForKey:@"Description"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ABMAlogo.png"]];
    UIColor *bg= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG.png"]];
    self.view.backgroundColor = bg;
    
    _imageView.layer.borderWidth = 1.0f;
    //_imageView.layer.borderColor = [UIColor concreteColor].CGColor;
    _imageView.layer.masksToBounds = NO;
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = 35;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
