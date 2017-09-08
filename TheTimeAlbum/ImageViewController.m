//
//  ImageViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/28.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "ImageViewController.h"
#import <JTSImageViewController.h>

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTap)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.cancelsTouchesInView = NO;
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:singleTap];
    
}

-(void)viewWillAppear:(BOOL)animated {
    //UINavigationBar.appearance.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems.firstObject.tintColor = [UIColor whiteColor];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
}

- (void) initialView {
    
    _imageView.image = _thisImage;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = _thisImage;
        if(_thisImage == nil) {
            NSLog(@"a");
            
        }else {
            NSLog(@"b");
        }
        
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) onImageTap {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.thisImage;
    imageInfo.referenceRect = self.view.frame;
    imageInfo.referenceView = self.view.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
}

@end
