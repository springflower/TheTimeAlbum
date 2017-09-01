//
//  ImageViewController.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/28.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarItem;
@property (strong, nonatomic) UIImage *thisImage;
@property (strong, nonatomic) NSString *thisPicName;

@end
