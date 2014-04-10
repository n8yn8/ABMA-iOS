//
//  ContactViewController.h
//  ABMA
//
//  Created by Nathan Condell on 4/9/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)clear:(id)sender;
- (IBAction)send:(id)sender;

@end
