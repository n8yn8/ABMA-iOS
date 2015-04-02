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
#import "Paper.h"
#import "PaperTableViewCell.h"

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
    
    [self.noteTextField resignFirstResponder];
    
    NSString *noteText = self.noteTextField.text;
    if (![noteText  isEqual: @""]) {
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        
        
        if (self.event) {
            if (!self.event.note) {
                self.event.note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
            }
            
            self.event.note.content = self.noteTextField.text;
        } else {
            if (!self.paper.note) {
                self.paper.note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
            }
            
            self.paper.note.content = self.noteTextField.text;
        }
        
        NSError *error;
        [context save:&error];
    }
    
    
    //TODO: error handling
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dayformatter = [[NSDateFormatter alloc] init];
    [dayformatter setDateFormat:@"EEEE"];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd"];
    
    if (self.paper) {
        self.eventDay.text = [[dayformatter stringFromDate:self.paper.event.startDate] uppercaseString];
        self.eventDate.text = [dateformatter stringFromDate:self.paper.event.startDate];
        self.eventLocation.text = self.paper.event.locatoin;
        self.eventTime.text = self.paper.event.time;
        self.eventTitle.text = self.paper.title;
        self.eventSubtitle.text = self.paper.author;
        self.eventDetails.text = self.paper.abstract;
        if (self.paper.note) {
            self.noteTextField.text = self.paper.note.content;
        }
    } else {
        self.eventDay.text = [[dayformatter stringFromDate:self.event.startDate] uppercaseString];
        self.eventDate.text = [dateformatter stringFromDate:self.event.startDate];
        self.eventLocation.text = self.event.locatoin;
        self.eventTime.text = self.event.time;
        self.eventTitle.text = self.event.title;
        self.eventSubtitle.text = self.event.subtitle;
        self.eventDetails.text = self.event.details;
        if (self.event.note) {
            self.noteTextField.text = self.event.note.content;
        }
    }
    
    if (self.event.papers.count > 0) {
        [self.tableView setHidden:NO];
        [self.eventDetails setHidden:YES];
    } else {
        [self.tableView setHidden:YES];
        [self.eventDetails setHidden:NO];
    }
    
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
    return [self.event.papers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PaperTableViewCell";
    
    PaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[PaperTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Paper *paper = [self.event.papers objectAtIndex:indexPath.row];
    cell.paperTitleLabel.text = paper.title;
    cell.authorLabel.text = paper.author;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPaper"]) {
        SchedDetailViewController* dvc = segue.destinationViewController;
        dvc.paper = self.event.papers[[self.tableView indexPathForSelectedRow].row];
    }
}

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
