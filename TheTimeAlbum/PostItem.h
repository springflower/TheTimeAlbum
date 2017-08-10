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
    PostTypeText,   // (= 0)
    PostTypeOnePic, // (= 1)
    PostTypeTwoPic,
    PostTypeThreePic
} PostType;


@interface PostItem : NSObject

@property (nonatomic, strong) NSString *content;

@property  NSInteger postID;
@property  NSInteger postTypeInt;
@property (nonatomic, strong) NSString *ofBabyID;
@property (nonatomic, strong) NSString *postDateString;

@property (nonatomic, strong) NSDate *postDate;

@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;
@property (nonatomic, assign) PostType postType;

@end
