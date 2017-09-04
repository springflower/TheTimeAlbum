//
//  MyCommunicator.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/25.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myDefines.h"
#import <AFNetworking.h>
#import "MyAccountData.h"

typedef void (^DoneHandler)(NSError *error, id result);

@interface MyCommunicator : NSObject
// 送出文字貼文
-(void) sendTextMessage:(NSString*) message
              forbabyID:(NSString*) babyID
               postType:(NSString*) postType
             completion:(DoneHandler) done;
// 將登入的FB GOOGLE用戶資訊寫入到 SQL以供查詢
-(void) registerUserToSQL:(MyAccountData*) userData
               completion:(DoneHandler) done;
// 加入新成就

-(void) addAchievementForbabyID:(NSString*) babyID
                          title:(NSString*) title
                        picName:(NSString*) picName
                     createDate:(NSString*) createDate
                     completion:(DoneHandler) done;


// 從SQL 撈uid 的功能
-(void) getUIDFromSQLByFBID:(NSString*) fbid
                 completion:(DoneHandler) done;



// 送出POST請求的功能
-(void) doPostWithURLString:(NSString*) urlString
                 parameters:(NSDictionary*) parameters
                       data:(NSData*) data
                 completion:(DoneHandler) done;

-(void) retrivePostsWithLastPostID:(NSString*)lastPostID
                            babyid:(NSString*)babyID
                        completion:(DoneHandler)done;
-(void) retriveAchievementsByBabyID:(NSString*)babyID
                         completion:(DoneHandler)done;

-(void) updatePostsToServerWithPostID:(NSInteger)postID
                              content:(NSString*)content
                           completion:(DoneHandler)done;
-(void) updatePostsToServerWithPostID:(NSInteger)postID
                             postType:(NSInteger)postType
                              content:(NSString*)content
                           completion:(DoneHandler)done;
- (void) deletePostByPostID:(NSInteger) postID
                 completion:(DoneHandler) done;

// 用uid取得這uid所擁有的寶寶們
- (void) getBabyDataByUID:(NSString*)uid completion:(DoneHandler)done;

+(instancetype) sharedInstance;
@end
