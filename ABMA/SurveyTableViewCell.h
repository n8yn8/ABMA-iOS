//
//  SurveyTableViewCell.h
//  ABMA
//
//  Created by Nathan Condell on 3/14/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
