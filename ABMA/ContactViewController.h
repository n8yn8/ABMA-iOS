//
//  ContactViewController.h
//  ABMA
//
//  Created by Nathan Condell on 4/9/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ContactViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (IBAction)abmaWebsite:(id)sender;
- (IBAction)abmaContactForm:(id)sender;

@end
