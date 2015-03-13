//
//  SponsorCollectionViewController.h
//  ABMA
//
//  Created by Nathan Condell on 4/7/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SponsorCollectionViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
