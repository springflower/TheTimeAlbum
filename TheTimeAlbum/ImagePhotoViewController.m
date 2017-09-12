//
//  ImagePhotoViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/9/12.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "SelectedRow.h"
#import "ImagePhotoViewController.h"

@interface ImagePhotoViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageVIew;

@end

@implementation ImagePhotoViewController
{
    NSMutableArray *ImageArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CATransition *transition = [CATransition animation];
    [transition setDuration:1];
    [transition setType:kCATransitionFade];
    [self.view.layer addAnimation:transition forKey:nil];
    
    ImageArray = [[NSMutableArray alloc] initWithArray:[[SelectedRow object] getImageArray]];
    
    if(ImageArray.count == 0) {
        return;
    }
    _ImageVIew.image = ImageArray[0];
    
    _scrollView.contentSize = _ImageVIew.frame.size;
    _scrollView.maximumZoomScale  = 3.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.zoomScale = 1.0;
    
    
    
}
- (IBAction)backLastPage:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    ImageArray = nil;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
