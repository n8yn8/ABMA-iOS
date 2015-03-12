//
//  EventCellTableViewCell.h
//  ABMA
//
//  Created by Nathan Condell on 3/9/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
