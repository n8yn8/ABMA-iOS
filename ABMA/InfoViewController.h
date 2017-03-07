//
//  InfoViewController.h
//  ABMA
//
//  Created by Nathan Condell on 3/21/15.
//  Copyright (c) 2015 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Info = 1,
    Welcome
} Mode;

@interface InfoViewController : BaseViewController

@property (nonatomic, assign) Mode mode;

@end
