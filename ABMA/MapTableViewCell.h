//
//  MapTableViewCell.h
//  ABMA
//
//  Created by Nathan Condell on 4/1/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
