//
//  timeLineVC.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/23.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlphaBlock)(CGFloat alpha);

@interface timeLineVC : UIViewController

@property (nonatomic, copy) AlphaBlock alphaBlock;

@end
