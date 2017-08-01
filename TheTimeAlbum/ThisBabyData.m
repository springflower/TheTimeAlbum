//
//  ThisBabyData.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/25.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "ThisBabyData.h"

static ThisBabyData *_currentBaby=nil;

@implementation ThisBabyData

// singleton method
+(instancetype) sharedCurrentBabyData {
    if(_currentBaby == nil){
        _currentBaby = [ThisBabyData new];
    }
    return _currentBaby;
}
//--

@end
