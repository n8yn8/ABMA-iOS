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
    
    if (indexPath.section == 0) {
        if (surveys.count == 0) {
            static NSString *simpleTableIdentifier = @"NoSurveys";
            return [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        }
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
    } else {
        static NSString *simpleTableIdentifier = @"NoSurveys";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.textLabel.text = indexPath.row == 0 ? @"ABMA Website" : @"Contact ABMA";
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Surveys";
    } else {
        return @"Links";
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return surveys.count == 0? 1 : surveys.count;
    }
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.theabma.org"] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://theabma.org/contact/"] options:@{} completionHandler:nil];
        }
        return;
    }
    Survey *survey = [surveys objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:survey.url];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end
