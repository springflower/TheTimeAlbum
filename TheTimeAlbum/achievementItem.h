//
//  achievementItem.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/7.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface achievementItem : NSObject


@property (nonatomic, strong) NSString *achievementTitle;
@property (nonatomic, strong) NSString *achievementPicName;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, assign) NSString *achievementCreatDate;
@property (nonatomic, assign) NSInteger achievementId;

@end
