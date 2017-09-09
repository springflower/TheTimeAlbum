//
//  UseDownloadDataClass.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "UseDownloadDataClass.h"

@implementation UseDownloadDataClass

- (id)init {
    self = [super init];
    if (self) {
        SuccessUpdated = true;
        
        DownloadOfChildBigStickerArray = [NSArray new];
        
        ChildSex = [NSString new];
        ChildName = [NSString new];
        ChildBirthday = [NSString new];
        WithChildRelationship = [NSString new];
        putChildInformationArray = [NSArray new];
        
        ChangeChildName = [NSString new];
        ChangeChildBirthday = [NSString new];
        putChangeChildInformationArray = [NSArray new];
    }
    return self;
}

+(instancetype)object
{
    static UseDownloadDataClass *testObject = nil;
    if(testObject == nil)
    {
        testObject = [[UseDownloadDataClass alloc]init];
    }
    return testObject;
}



#pragma mark - put downloadChildBigStickerArray to Singleton 準備將下載好的孩子大頭貼資料放置全域的陣列供讀取

-(void)PutChildBigStickerArray:(NSArray *)ReadChildBigStickerArray {
    
    DownloadOfChildBigStickerArray = ReadChildBigStickerArray;
}

#pragma mark - read downloadChildBigStickerArray form Singleton 準備讀取存取的孩子大頭貼資料陣列

-(NSArray*)ReadChildBigStickerArray {
    
    return DownloadOfChildBigStickerArray;
}

#pragma  mark - put update is Success or Fail BOOL 準備放置一個布林值判斷是否上傳成功

-(void)PutSuccessUpdateBool:(BOOL)SucessOrNot {
    
    SuccessUpdated = SucessOrNot;
}

#pragma  mark - read update is Success or Fail BOOL 準備讀取布林值判斷是否上傳成功

-(BOOL)ReadSuccessUpdateBool {
    
    return SuccessUpdated;
}


-(void)PutChildInformation:(NSString *)childName ChildBirthday:(NSString *)childBirthday
                  ChildSex:(NSString *)childSex WithChildRelationShip:(NSString *)withchildRelationShip {
    
    ChildName = childName;
    ChildBirthday = childBirthday;
    ChildSex = childSex;
    WithChildRelationship = withchildRelationShip;
    putChildInformationArray = @[ChildName,ChildBirthday,ChildSex,WithChildRelationship];
}

-(NSArray*)ReadChildInformationArray {
    
    return putChildInformationArray;
}

#pragma mark - put ready data to update 準備儲存資料準備上傳的資料

-(void)PutChangeChildInformation:(NSString *)changeChildName
             ChangeChildBirthday:(NSString *)changeChildBirthday {
    
    ChangeChildName = changeChildName;
    ChangeChildBirthday = changeChildBirthday;
    putChangeChildInformationArray = @[ChangeChildName,ChangeChildBirthday];
}

#pragma mark - read ready data 準備讀取儲存的資料進行上傳

-(NSArray*)ReadChangeChildInformationArray {
    
    return putChangeChildInformationArray;
}


@end
