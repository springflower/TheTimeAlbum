//
//  SelectedRow.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/5.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "SelectedRow.h"

@implementation SelectedRow

- (id)init {
    self = [super init];
    if (self) {
        
        //將COUNT初始化為0
        SelectRow = 0;
        Value = false;
    }
    
    return self;
}

+(instancetype)object
{
    static SelectedRow *testObject = nil;
    if(testObject == nil)
    {
        testObject = [[SelectedRow alloc]init];
    }
    return testObject;
}

-(void)SendSelectedRowAboutMail:(int)selected Bool:(BOOL)value {
    SelectRow = selected;
    Value = value;
}

- (int)didSelectedRowAboutMail; {

    return SelectRow;
}

- (BOOL)didSelectedNewOrOldAboutMail {
    
    return Value;
}



@end
