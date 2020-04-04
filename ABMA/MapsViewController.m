//
//  MapsViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/1/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

#import "MapsViewController.h"
#import "AppDelegate.h"
#import "Year+CoreDataClass.h"
#import "Map+CoreDataClass.h"
#import "BaseViewController.h"
#import "MapTableViewCell.h"
@import SDWebImage;
#import "MapDetailViewController.h"

@interface MapsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MapsViewController {
    NSArray<Map*> *maps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    Year *year = [Year getLatestYear:nil context:context];
    maps = [year.maps allObjects];
    
    self.tableView.rowHeight = 160;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source Delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    Map *map = [maps objectAtIndex:indexPath.row];
    
    static NSString *simpleTableIdentifier = @"MapCell";
    
    MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell.mapImageView sd_setImageWithURL:[NSURL URLWithString:map.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"Error %@", error);
    }];
    [cell.titleLabel setText:map.title];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return maps.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Map *map = [maps objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showMap" sender:map];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        MapDetailViewController *dvc = segue.destinationViewController;
        dvc.map = sender;
    }
}

@end
