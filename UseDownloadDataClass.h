//
//  UseDownloadDataClass.h
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UseDownloadDataClass : NSObject {

@private
    
    
BOOL SuccessUpdated;

//準備放置孩子大頭貼資料至陣列中
NSArray *DownloadOfChildBigStickerArray;

//準備放置孩子姓名
NSString *ChildName;
//準備放置孩子生日
NSString *ChildBirthday;
//準備放置孩子性別
NSString *ChildSex;
//準備放置與孩子的關係
NSString *WithChildRelationship;
//準備放置資料到陣列中
NSArray *putChildInformationArray;

//準備放置改變後的孩子姓名
NSString *ChangeChildName;
//準備放置改變後的孩子生日
NSString *ChangeChildBirthday;
//準備放置改變後的孩子資料至陣列中
NSArray *putChangeChildInformationArray;
    
}


+(instancetype) object;

-(NSArray*)ReadChildBigStickerArray;

-(void)PutChildBigStickerArray:(NSArray*)ChildBigStickerArray;

-(void)PutSuccessUpdateBool:(BOOL)SucessOrNot;

-(BOOL)ReadSuccessUpdateBool;

-(void)PutChildInformation:(NSString *)childName ChildBirthday:(NSString *)childBirthday
                  ChildSex:(NSString *)childSex WithChildRelationShip:(NSString *)withchildRelationShip;

-(NSArray*)ReadChildInformationArray;

-(void)PutChangeChildInformation:(NSString *)changeChildName
             ChangeChildBirthday:(NSString *)changeChildBirthday;

-(NSArray*)ReadChangeChildInformationArray;



@end
