//
//  ContactViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/9/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import "ContactViewController.h"
#import "SWRevealViewController.h"
#import "Year+CoreDataClass.h"
#import "AppDelegate.h"
#import "Survey+CoreDataClass.h"
#import "SurveyTableViewCell.h"
#import "ABMA-Swift.h"

@interface ContactViewController ()
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UITableView *surveysTableView;

@end

@implementation ContactViewController {
    NSMutableArray<Survey*> *surveys;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.websiteButton.layer.cornerRadius = 6;
    self.contactButton.layer.cornerRadius = 6;
    
    self.surveysTableView.delegate = self;
    self.surveysTableView.dataSource = self;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    Year *year = [Year getLatestYear:nil context:context];
    
    surveys = [[NSMutableArray alloc] init];
    NSDate *now = [[NSDate alloc] init];
    for (Survey *survey in year.surveys) {
        if (now.timeIntervalSince1970 > survey.start.timeIntervalSince1970 && now.timeIntervalSince1970 < survey.end.timeIntervalSince1970) {
            [surveys addObject:survey];
        }

    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SurveyCell";
    
    SurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[SurveyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Survey *survey = [surveys objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = survey.title;
    cell.detailsLabel.text = survey.details;
    cell.timeLabel.text = [NSString stringWithFormat:@"Available until %@", [Utils timeWithEndDate:survey.end]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return surveys.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Survey *survey = [surveys objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:survey.url];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)abmaWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.theabma.org"]];
}

- (IBAction)abmaContactForm:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://theabma.org/contact/"]];
}

@end
