//
//  MyAccountData.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 登入的類型
typedef enum {
    LoginTypeFacebook,   // (= 0)
    LoginTypeGoogle  // (= 1)
} LoginType;

@interface MyAccountData : NSObject

@property(nonatomic,weak) NSString      *firstName;
@property(nonatomic,weak) NSString      *lastName;
@property(nonatomic,weak) NSString      *userName;
@property(nonatomic,weak) NSString      *userId;
@property(nonatomic,weak) NSString      *userFBId;
@property(nonatomic,weak) NSString      *userGoogleId;
@property(nonatomic,weak) NSString      *userPic;
@property(nonatomic,weak) NSString      *gender;
@property(nonatomic,weak) NSString      *userMail;

+(instancetype) sharedCurrentUserData;
@end
