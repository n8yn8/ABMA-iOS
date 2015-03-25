//
//  PaperTableViewCell.h
//  ABMA
//
//  Created by Nathan Condell on 3/22/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaperTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *paperTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end
