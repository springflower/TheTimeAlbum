//
//  ImagePageViewController.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/28.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePageViewController : UIViewController

@property (weak, nonatomic) NSMutableArray *imageNameArray;
@property (weak, nonatomic) NSMutableArray *ivcs;
@property (weak, nonatomic) NSString *allImageNameStr;
@property NSInteger postID;

@end
