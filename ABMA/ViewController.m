//
//  ViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/6/14.
//  Copyright (c) 2014 Nathan Condell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ABMAlogo.png"]];
    UIColor *bg= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG.png"]];
    self.view.backgroundColor = bg;

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
