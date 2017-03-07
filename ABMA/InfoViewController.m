//
//  InfoViewController.m
//  ABMA
//
//  Created by Nathan Condell on 3/21/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import "InfoViewController.h"
#import "Year+CoreDataClass.h"
#import "AppDelegate.h"

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    NSFetchRequest<Year*> *yearRequest = [Year fetchRequest];
    yearRequest.fetchLimit = 1;
    yearRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO]];
    NSError *error = nil;
    Year *year = [context executeFetchRequest:yearRequest error:&error].firstObject;
    if (year) {
        if (self.mode == Info) {
            self.contentTextView.text = year.info;
        } else if (self.mode == Welcome) {
            self.contentTextView.text = year.welcome;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
