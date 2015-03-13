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

@interface SchedDetailViewController () <UITextFieldDelegate>

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
    note.content = self.noteTextField.text;
    note.event = self.event;
    NSError *error;
    [context save:&error];
    //TODO: error handling
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dayformatter = [[NSDateFormatter alloc] init];
    [dayformatter setDateFormat:@"EEEE"];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd"];
    
    self.eventDay.text = [[dayformatter stringFromDate:self.event.startDate] uppercaseString];
    self.eventDate.text = [dateformatter stringFromDate:self.event.startDate];
    self.eventTitle.text = self.event.title;
    self.eventSubtitle.text = self.event.subtitle;
    self.eventLocation.text = self.event.locatoin;
    self.eventTime.text = self.event.time;
    self.eventDetails.text = self.event.details;
    if (self.event.note) {
        self.noteTextField.text = self.event.note.content;
    }
    
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
