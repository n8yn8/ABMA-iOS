//
//  NotesViewController.m
//  ABMA
//
//  Created by Nathan Condell on 3/12/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import "NotesViewController.h"
#import "Event.h"
#import "Paper.h"
#import "Note.h"
#import "AppDelegate.h"
#import "SchedDetailViewController.h"

@interface NotesViewController () {
    NSArray *notes;
}

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Note" inManagedObjectContext:context]];
    NSError *fetchError = nil;
    notes = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&fetchError]];
    if (fetchError) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
