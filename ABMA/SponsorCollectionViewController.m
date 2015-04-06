//
//  SponsorCollectionViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import "SponsorCollectionViewController.h"
#import "SWRevealViewController.h"

@interface SponsorCollectionViewController ()

@end

@implementation SponsorCollectionViewController
{
    NSArray *sponsorImages;
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
    
    //Sponsor image array
//    sponsorImages = [[NSArray alloc] initWithObjects:@"AAZK-Dallas.png", @"AAZK-Galv.png", @"AAZKChey.png", @"ABI.png", @"AP.png", @"Blue.png", @"ChildrensAquarium.png", @"Cliff.png", @"DallasZoo.png", @"DWA.png", @"FRWC.png", @"FWZoo.png", @"MAF.png", @"NatBal.png", @"NEI.png", @"SeaWorld.png", nil];
    sponsorImages = [[NSArray alloc] initWithObjects:@"DBP.png", @"CPHZoo.png", @"GIVSKUD_ZOO.png", @"Odense Zoo.png", @"SDU.png", @"training_store.png", @"mazuri.png", @"profis.png", @"sea_world.png",  nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [sponsorImages count];
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
    
    imageView.image = [UIImage imageNamed:[sponsorImages objectAtIndex:indexPath.row]];
    
    return cell;
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
