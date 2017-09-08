//
//  PostItem.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/6.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    PostTypeText = 1,   //如果沒設定是從 (= 0) 開始
    PostTypeOnePic, // (= 1)
    PostTypeTwoPic,
    PostTypeThreePic,
    PostTypeUploading
} PostType;


@interface PostItem : NSObject

@property (nonatomic, strong) NSString *content;

@property  NSInteger postID;
@property  NSInteger postTypeInt;
@property  NSInteger howManyDaysFromBirthday;
@property (nonatomic, strong) NSString *ofBabyID;
@property (nonatomic, strong) NSString *postDateString;
@property (nonatomic, strong) NSString *finalDisplayDateStr;
@property (nonatomic, strong) NSDate *postDate;

@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;
@property (nonatomic, strong) NSNumber *photoNum;
@property NSInteger photoNum2;
@property (nonatomic, assign) PostType postType;

@property (nonatomic, assign) NSInteger itemIndex;
@end
