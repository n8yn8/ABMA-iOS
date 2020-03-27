//
//  MapDetailViewController.m
//  ABMA
//
//  Created by Nathan Condell on 4/1/18.
//  Copyright © 2018 Nathan Condell. All rights reserved.
//

#import "MapDetailViewController.h"
@import SDWebImage;

@interface MapDetailViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.delegate = self;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.map.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"Error %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
