//
//  NotesViewController.m
//  ABMA
//
//  Created by Nathan Condell on 3/12/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import "NotesViewController.h"
#import "Event+CoreDataClass.h"
#import "Paper+CoreDataClass.h"
#import "Note+CoreDataClass.h"
#import "AppDelegate.h"
#import "SchedDetailViewController.h"
#import "ABMA-Swift.h"
#import <Crashlytics/Crashlytics.h>

@interface NotesViewController () {
    NSArray *notes;
    NSManagedObjectContext *context;
}

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    
    [self fetchNotes];
    
    [self checkUser];
    
}

- (void)fetchNotes {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Note" inManagedObjectContext:context]];
    NSError *fetchError = nil;
    notes = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&fetchError]];
    if (fetchError) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    [self.tableView reloadData];
}

- (void)checkUser {
    BackendlessUser *user = [[DbManager sharedInstance] getCurrentUser];
    if (user) {
        [self hideLogin];
        for (Note *note in notes) {
            if (note.bObjectId == nil) {
                [Utils saveWithNote:note context:context];
            }
        }
    }
}

- (IBAction)login:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log in" message:@"Have you created an account before?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Have account" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showLoginIsNew: NO];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showLoginIsNew: YES];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Login cancelled");
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showLoginIsNew:(BOOL)isNew {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log in" message:@"Enter email and password" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.activityIndicator startAnimating];
        [self.loginButton setEnabled:NO];
        NSString *email = alertController.textFields[0].text;
        NSString *password = alertController.textFields[1].text;
        if (isNew) {
            [[DbManager sharedInstance] registerUserWithEmail:email password:password callback:^(NSString * _Nullable error) {
                [Answers logSignUpWithMethod:@"Email" success:@(error == nil) customAttributes:@{@"error": error}];
                [self handleResponse:error];
            }];
        } else {
            [[DbManager sharedInstance] loginWithEmail:email password:password callback:^(NSString * _Nullable error) {
                [Answers logLoginWithMethod:@"Email" success: @(error == nil) customAttributes:@{@"error": error}];
                [self handleResponse:error];
            }];
        }
    }];
    loginAction.enabled = NO;
    [alertController addAction:loginAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Email";
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            if (![textField.text isEqualToString:@""]) {
                loginAction.enabled = YES;
            }
        }];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Login cancelled");
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleResponse:(NSString * _Nullable)error {
    [self.activityIndicator stopAnimating];
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        [self retrieveOnlineNotes];
    }
    [self checkUser];
}

- (void)retrieveOnlineNotes {
    [_activityIndicator startAnimating];
    [[DbManager sharedInstance] getNotesWithCallback:^(NSArray<BNote *> * _Nullable bNotes, NSString * _Nullable error) {
        for (BNote *bNote in bNotes) {
            Note *note = nil;
            Paper *foundPaper = nil;
            Event *foundEvent = nil;
            if (bNote.paperId) {
                NSFetchRequest *paperRequest = [Paper fetchRequest];
                paperRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==%@", bNote.paperId];
                NSError *error = nil;
                NSArray <Paper *> *matches = [context executeFetchRequest:paperRequest error:&error];
                if (matches.count) {
                    foundPaper = [matches firstObject];
                    note = foundPaper.note;
                }
            } else {
                NSFetchRequest *eventRequest = [Event fetchRequest];
                eventRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==%@", bNote.eventId];
                NSError *error = nil;
                NSArray <Event *> *matches = [context executeFetchRequest:eventRequest error:&error];
                if (matches.count) {
                    foundEvent = [matches firstObject];
                    note = foundEvent.note;
                }
            }
            
            
            if (!note) {
                note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
            } else {
                //TODO: check for updated note
            }
            note.bObjectId = bNote.objectId;
            note.content = bNote.content;
            note.updated = bNote.updated;
            note.created = bNote.created;
            note.event = foundEvent;
            note.paper = foundPaper;
        }
        NSError *saveError = nil;
        [context save:&saveError];
        [self.activityIndicator stopAnimating];
        [self fetchNotes];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideLogin {
    self.loginView.hidden = true;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NoteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *eventNameLabel = (UILabel *)[cell viewWithTag:201];
    UILabel *noteContent = (UILabel *)[cell viewWithTag:202];
    
    Note *note = [notes objectAtIndex:indexPath.row];
    if (note.event) {
        Event *thisEvent = note.event;
        eventNameLabel.text = thisEvent.title;
    } else if (note.paper) {
        Paper *thisPaper = note.paper;
        eventNameLabel.text = thisPaper.title;
    }
    
    noteContent.text = note.content;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Note *selectedNote = notes[indexPath.row];
        SchedDetailViewController* dvc = segue.destinationViewController;
        if (selectedNote.event) {
            Event *selectedEvent = selectedNote.event;
            dvc.event = selectedEvent;
        } else if (selectedNote.paper) {
            Paper *selectedPaper = selectedNote.paper;
            dvc.paper = selectedPaper;
        }
    }
}

@end
