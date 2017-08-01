//
//  SaveMyFutureMail.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/31.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "SaveMyFutureMail.h"

static SaveMyFutureMail *save = nil;


@implementation SaveMyFutureMail

-(instancetype)shareFutureMail {
    
    if(save == nil){
        save = [SaveMyFutureMail new];
        _keep = [NSMutableArray new];
    }
    return save;
}

@end
