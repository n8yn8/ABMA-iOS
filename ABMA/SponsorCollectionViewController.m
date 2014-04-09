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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ABMAlogo.png"]];
    UIColor *bg= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG.png"]];
    self.view.backgroundColor = bg;
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Sponsor image array
    sponsorImages = [[NSArray alloc] initWithObjects:@"AAZK-Dallas.png", @"AAZK-Galv.png", @"AAZKChey.png", @"ABI.png", @"AP.png", @"Blue.png", @"ChildrensAquarium.png", @"Cliff.png", @"DallasZoo.png", @"DWA.png", @"FRWC.png", @"FWZoo.png", @"MAF.png", @"NatBal.png", @"NEI.png", @"SeaWorld.png", nil];
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
