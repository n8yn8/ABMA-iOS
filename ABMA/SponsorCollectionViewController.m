//
//  SponsorCollectionViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import "SponsorCollectionViewController.h"
#import "SWRevealViewController.h"
@import SDWebImage;
#import "AppDelegate.h"
#import "Sponsor+CoreDataClass.h"
#import "Year+CoreDataClass.h"
#import "ABMA-Swift.h"

@interface SponsorCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *sponsorsCollectionView;

@end

@implementation SponsorCollectionViewController
{
    NSArray<Sponsor *> *sponsors;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sponsors = [[NSArray alloc] init];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    NSFetchRequest<Year*> *yearRequest = [Year fetchRequest];
    yearRequest.fetchLimit = 1;
    yearRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO]];
    NSError *error = nil;
    Year *year = [context executeFetchRequest:yearRequest error:&error].firstObject;
    if (year) {
        sponsors = [year.sponsors allObjects];
        if (sponsors.count) {
            NSLog(@"Sponsors exist");
        } else {
            [[DbManager sharedInstance] getSponsorsWithYearId:year.bObjectId callback:^(NSArray<BSponsor *> * _Nullable response, NSString * _Nullable error) {
                if (error) {
                    [Utils handleErrorWithMethod:@"GetPublishedYears" message:error];
                    NSLog(@"error: %@", error);
                } else {
                    NSMutableArray<Sponsor*> *netSponsors = [[NSMutableArray alloc] initWithCapacity:response.count];
                    for (BSponsor *bSponsor in response) {
                        
                        NSFetchRequest<Sponsor*> *sponsorRequest = [Sponsor fetchRequest];
                        sponsorRequest.fetchLimit = 1;
                        sponsorRequest.predicate = [NSPredicate predicateWithFormat:@"bObjectId==%@", bSponsor.objectId];
                        NSError *sponsorError = nil;
                        Sponsor *sponsor = [context executeFetchRequest:sponsorRequest error:&sponsorError].firstObject;
                        if (!sponsor) {
                            sponsor = [[Sponsor alloc] initWithEntity:[NSEntityDescription entityForName:@"Sponsor" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                        }
                        sponsor.bObjectId = bSponsor.objectId;
                        sponsor.url = bSponsor.url;
                        sponsor.imageUrl = bSponsor.imageUrl;
                        sponsor.year = year;
                        sponsor.created = bSponsor.created;
                        sponsor.updated = bSponsor.updated;
                        [year addSponsorsObject:sponsor];
                        [netSponsors addObject:sponsor];
                    }
                    NSError *error;
                    [context save:&error];
                    if (error) {
                        NSLog(@"Error: %@", error.localizedDescription);
                    } else {
                        self->sponsors = netSponsors;
                        [self.sponsorsCollectionView reloadData];
                    }
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [sponsors count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(self.view.bounds.size.width/2, self.view.bounds.size.width/2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //referencing the attributes of our cell
    static NSString *identifier = @"Sponsor";
    //start our virtual loop through the cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //instantiate the imageview in each cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:200];
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *) [cell viewWithTag:201];
    [activityIndicator startAnimating];
    
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:sponsors[indexPath.item].imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [activityIndicator stopAnimating];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedLink = [sponsors objectAtIndex:indexPath.item].url;
    if (selectedLink) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: selectedLink] options:@{} completionHandler:nil];
    }
    
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
