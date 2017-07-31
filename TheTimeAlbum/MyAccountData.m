//
//  MyAccountData.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "MyAccountData.h"

static MyAccountData *_currentUser=nil;

@implementation MyAccountData

// singleton method
+(instancetype) sharedCurrentUserData {
    if(_currentUser == nil){
        _currentUser = [MyAccountData new];
    }
    return _currentUser;
}
//--

-(instancetype)init{
    self = [super init];
    
    return self;
}
-(instancetype)initWithName:(NSString*)username
                       mail:(NSString*)usermail
                        uid:(NSString*)userid
                     gender:(NSString*)gender{
    self = [super init];
    
    return self;
}







@end
