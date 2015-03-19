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

@interface SchedDetailViewController () <UITextViewDelegate>

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
    
    _noteTextField.delegate = self;
    _eventDetails.delegate = self;
    [self.view endEditing:YES];
    
    [self.view endEditing:YES];
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

#pragma mark - Textfield control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.noteTextField isFirstResponder] && [touch view] != self.noteTextField) {
        [self.noteTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)textViewDidBeginEditing:(UITextView *)textField
{
    
    if (textField == self.noteTextField) {
        self.eventDetails.userInteractionEnabled = NO;
    }
    
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textField
{
    
    if (textField == self.noteTextField) {
        self.eventDetails.userInteractionEnabled = YES;
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
