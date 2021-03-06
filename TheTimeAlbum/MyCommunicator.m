//
//  MyCommunicator.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/25.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "MyCommunicator.h"

static MyCommunicator *_singletonCommunicator = nil;

@implementation MyCommunicator

// singleton
+(instancetype) sharedInstance {
    if(_singletonCommunicator==nil) {
        _singletonCommunicator = [MyCommunicator new];
    }
    return _singletonCommunicator;
}
//--

-(void) sendTextMessage:(NSString*) message
              forbabyID:(NSString*) babyID
               postType:(NSString*) postType
             completion:(DoneHandler) done {
    
    NSDictionary *parameters = @{CONTENT_KEY: message, BABYID_KEY: babyID,
                   TYPE_KEY: postType};
    NSLog(@"parameters: %@", parameters);
    
    // 通用API(自製) 向server送出post指令
    [self doPostWithURLString:SEND_MESSAGE_URL
                   parameters:parameters
                         data:nil
                   completion:done];
    
}

-(void) registerUserToSQL:(MyAccountData*) userData
               completion:(DoneHandler) done{
    
    NSString *userID = userData.userId;//
    NSString *userFBId = userData.userFBId;
    NSString *userMail = userData.userMail;
    NSString *userPic = userData.userPic;//
    NSString *userName = userData.userName;
    NSString *userGoogleId = userData.userGoogleId;
    
    NSDictionary *parameters = nil;
    
    NSLog(@"---userData : id: %@, FB: %@, mail: %@, name: %@, google: %@", userID, userFBId, userMail, userName, userGoogleId);
    if(userGoogleId == nil){
        parameters = @{USER_NAME_KEY: userName,
                                     USER_MAIL_KEY: userMail,
                                     USER_FB_KEY: userFBId};
    } else if (userFBId == nil) {
        parameters = @{USER_NAME_KEY: userName,
                                     USER_MAIL_KEY: userMail,
                                     USER_GOOGLE_KEY: userGoogleId};
    } else {
        NSLog(@"*** no google id or fb id in userData...");
    }
    
    
    // 通用API(自製) 向server送出post指令
    [self doPostWithURLString:REGISTER_URL
                   parameters:parameters
                         data:nil
                   completion:done];
}

// 新增成就到SQL
-(void) addAchievementForbabyID:(NSString*) babyID
                          title:(NSString*) title
                        picName:(NSString*) picName
                     createDate:(NSString*) createDate
                createDateStamp:(NSTimeInterval) createDateStamp
                     completion:(DoneHandler) done {
    
    NSDictionary *parameters = @{@"babyId": babyID,
                                 @"title": title,
                                 @"picName": picName,
                                 @"createDateStamp": @(createDateStamp),
                                 @"createDate": createDate};
    NSLog(@"parameters: %@", parameters);
    
    // 通用API(自製) 向server送出post指令
    [self doPostWithURLString:ADD_ACHIEVEMENT_URL
                   parameters:parameters
                         data:nil
                   completion:done];
    
}
// 新增新的小孩
- (void) addChildToServerWithBabyName:(NSString*) babyName
                         babyBirthday:(NSString*) babyBirthday
                           babyGender:(NSString*) babyGender
                   senderRelationShip:(NSString*) senderRelationship
                            senderUID:(NSString*) senderUID
                          babyPicName:(NSString*) babyPicName
                           completion:(DoneHandler) done {

    NSDictionary *parameters = @{@"babyName": babyName,
                                 @"babyBirthday": babyBirthday,
                                 @"babyGender": babyGender,
                                 @"senderRelationship": senderRelationship,
                                 @"senderUID": senderUID,
                                 @"babyPicName": babyPicName };
    NSLog(@"parameters: %@", parameters);
    
    // 通用API(自製) 向server送出post指令
    [self doPostWithURLString:ADD_BABY_URL
                   parameters:parameters
                         data:nil
                   completion:done];

}



// 從SQL 撈uid 的功能
-(void) getUIDFromSQLByFBID:(NSString*) fbid
                      completion:(DoneHandler) done{
    
    NSString *aa = fbid;
    NSString *bb = @"12342a";
    NSDictionary *parameters = @{FBKEYTEMP_KEY: aa, USER_GOOGLE_KEY: bb};
    NSLog(@"-- getUID params : %@", parameters);
    
    [self doPostWithURLString:GET_UID_URL
                   parameters:parameters
                         data:nil
                   completion:done];
    
    //return nil;
}

#pragma mark - retriveMessages from server by babyid  用babybid從伺服器抓訊息

-(void) retrivePostsWithLastPostID:(NSString*)lastPostID babyid:(NSString*)babyID completion:(DoneHandler)done{
    
    NSDictionary *parameters = @{ BABYID2: babyID };
    // @{}--> NSDictionary
    // @[]--> NSArray
    // @()--> NSNumber
    NSLog(@"--do in retrive PostsWithLastPostId");
    [self doPostWithURLString:RETRIVE_POSTS_URL
                   parameters:parameters
                         data:nil
                   completion:done];
}

-(void) retriveAchievementsByBabyID:(NSString*)babyID completion:(DoneHandler)done {

    NSDictionary *parameters = @{ BABYID2: babyID };
    NSLog(@"--do in retrive Achievement by babyid");
    [self doPostWithURLString:RETRIVE_ACHIEVEMENTS_URL
                   parameters:parameters
                         data:nil
                   completion:done];
    
}

- (void) getBabyDataByUID:(NSString*)uid completion:(DoneHandler)done {
    
    NSDictionary *parameters = @{ @"uid": uid};
    NSLog(@"--do in getBabyDataByUID ");
    [self doPostWithURLString:GET_BABY_DATA_BY_UID_URL
                   parameters:parameters
                         data:nil
                   completion:done];

}




#pragma mark - updatePosts to server        
// 修改貼文的內容
-(void) updatePostsToServerWithPostID:(NSInteger)postID
                              content:(NSString*)content
                           completion:(DoneHandler)done {
    //...
    NSDictionary *params = @{ @"postId": @(postID),
                              @"content": content   };
    
    [self doPostWithURLString:UPDATE_POST_URL
                   parameters:params
                         data:nil
                   completion:done];

}

// 修改貼文的內容
-(void) updatePostsToServerWithPostID:(NSInteger)postID
                             postType:(NSInteger)postType
                              content:(NSString*)content
                           completion:(DoneHandler)done {
    //...
    NSDictionary *params = @{ @"postId": @(postID),
                              @"postType": @(postType),
                              @"content": content   };
    
    [self doPostWithURLString:UPDATE_POST_URL2
                   parameters:params
                         data:nil
                   completion:done];
    
}

// 修改寶寶的圖片
- (void) updateBabyDataToSQLWithPicName:(NSString*) babyPicName
                               babyName:(NSString*) babyName
                           babyBirthday:(NSString*) babyBirthday
                                 babyID:(NSInteger) babyID
                             completion:(DoneHandler)done {
    NSMutableDictionary *temp;
    temp = [NSMutableDictionary new];
    NSDictionary *params;
    NSLog(@"奇怪了上傳資料: %@, %@, %@, %ld", babyPicName,babyName,babyBirthday,babyID);
    if (babyPicName != nil){
    
        [temp setObject:babyPicName forKey:@"babyPicName"];
    }
    if (babyName != nil) {
        //NSLog(@"??");
        [temp setObject:babyName  forKey:@"babyName"];
    }
    if (babyBirthday != nil){
    
        [temp setObject:babyBirthday forKey:@"babyBirthday"];
    }
    NSString *tempID = [NSString stringWithFormat:@"%ld",babyID];
    [temp setObject:tempID forKey:@"babyID"];
    //NSLog(@" temp : %@", temp);
    //NSLog(@" ???: %@", [temp objectForKey:@"babyName"]);
    params = temp;
    [self doPostWithURLString:UPDATE_BABY_DATA
                   parameters:params
                         data:nil
                   completion:done];
}

// 刪除貼文
- (void) deletePostByPostID:(NSInteger) postID
                 completion:(DoneHandler) done{

    //...
    NSDictionary *params = @{ @"postId": @(postID)};
    
    [self doPostWithURLString:DELETE_POST_URL
                   parameters:params
                         data:nil
                   completion:done];
}

// 刪除成就
- (void) deleteAchievementByID:(NSInteger) achievementID
                 completion:(DoneHandler) done{
    
    //...
    NSDictionary *params = @{ @"achievementID": @(achievementID)};
    
    [self doPostWithURLString:DELETE_ACHIEVEMENT_URL
                   parameters:params
                         data:nil
                   completion:done];
}
// 刪除寶寶
- (void) deleteBabyByBabyID:(NSInteger) babyID
                 completion:(DoneHandler) done{
    
    //...
    NSDictionary *params = @{ @"babyID": @(babyID)};
    
    [self doPostWithURLString:DELETE_BABY_URL
                   parameters:params
                         data:nil
                   completion:done];
}


#pragma mark - Private Method to handle POST job.
// 設計通用API 來送出url request
-(void) doPostWithURLString:(NSString*) urlString
                 parameters:(NSDictionary*) parameters
                       data:(NSData*) data
                 completion:(DoneHandler) done {
    
    //      Prepare parameters
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    //  傳error位址到上面 當上面方法執行完 此位址error的值已經被改變
    if(error){
        NSLog(@"--NSJSONSerialization Error: %@", error.description);
        // @@ done 宣告的doneHandler就是帶兩個參數
        done(error, nil);
        return;
    }
//      準備資料:
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"--doPostParameters: %@", jsonString);
    //
    NSDictionary *finalParameters = @{DATA_KEY:jsonString};
    
    //      Perform Post Action
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 設定回傳接受的資料類型 如果沒設定 afnetworking會擋掉                          // MIME-TYPE
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    // @5)
    // 送出post請求----> 3個block 1. uploadProgress: 進度 2.上傳成功 透過此block告訴結果3. 同2 但是上傳失敗
    [manager POST:urlString
       parameters:finalParameters
       constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             if(data != nil){
                [formData appendPartWithFileData:data
                                    name:@"fileToUpload"   //Important!
                                fileName:@"image.jpg"
                                mimeType:@"image/jpg"];
             }
         }
         progress:^(NSProgress * _Nonnull uploadProgress) {
             // @9)
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              // @10)
              NSLog(@"doPOST OK: %@", responseObject);
              if(done != nil){
                  done(nil, responseObject);
              }
              // @13)
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              // @10')
              NSLog(@"doPOST Fail: %@", error);
              if(done){
                  done(error, nil);
              }
              // @13')
          }];
    // @6)
    
}





@end







