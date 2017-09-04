//
//  myDefines.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/23.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#ifndef myDefines_h
#define myDefines_h


#define RESULT_KEY              @"success"
#define SER_BACK_MESSAGE_KEY    @"message"
#define ERROR_CODE_KEY          @"errorCode"
#define CONTENT_KEY             @"content"
#define TYPE_KEY                @"type"
#define BABYID_KEY              @"babyID"
#define BABYID                  @"babyid"
#define BABYID2                 @"babyId"
#define DATA_KEY                @"data"


#define USER_NAME_KEY           @"userName"
#define SENDER_UID_KEY              @"senderUID"
#define USER_MAIL_KEY           @"userMail"
#define USER_FB_KEY             @"userFBId"
#define USER_GOOGLE_KEY         @"google_id"
#define FBKEYTEMP_KEY               @"fbid"

// posts
#define POSTS_KEY                @"Posts"
#define POST_KEY                @"Message"
#define POST_ID_KEY                @"postId"
#define LAST_POST_ID_KEY        @"lastPostId"


// Achievements
#define ACHIEVEMENTS_KEY                @"Achievements"
#define LAST_ACHIEVEMENT_ID_KEY         @"lastAchievementId"

//#define SEND_TEXT_MESSAGE_URL   @""

#define headRect CGRectMake(0,0,self.view.bounds.size.width,220)
#define VCWidth self.view.bounds.size.width
#define VCHeight self.view.bounds.size.height
#define navHeight 0 //上推留下的高度
#define NAV_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define SERVER_URL @"http://127.0.0.1/thetimealbum/"
#define SEND_MESSAGE_URL @"https://jerrygood9999.000webhostapp.com/thetimealbum/create_textMessage.php"


#define ADD_ACHIEVEMENT_URL @"https://jerrygood9999.000webhostapp.com/thetimealbum/addAchievement.php"

#define GET_UID_URL     @"https://jerrygood9999.000webhostapp.com/thetimealbum/get_uid.php"
#define REGISTER_URL     @"https://jerrygood9999.000webhostapp.com/thetimealbum/new_register.php"
#define RETRIVE_POSTS_URL     @"https://jerrygood9999.000webhostapp.com/thetimealbum/retriveMessages2.php"
#define RETRIVE_ACHIEVEMENTS_URL     @"https://jerrygood9999.000webhostapp.com/thetimealbum/retriveAchievements.php"
#define UPDATE_POST_URL     @"https://jerrygood9999.000webhostapp.com/thetimealbum/updatePost.php"
#define UPDATE_POST_URL2     @"https://jerrygood9999.000webhostapp.com/thetimealbum/updatePost2.php"
#define DELETE_POST_URL     @"https://jerrygood9999.000webhostapp.com/thetimealbum/deletePost.php"

#define GET_BABY_DATA_BY_UID_URL @"https://jerrygood9999.000webhostapp.com/thetimealbum/getBabyDataByUID.php"



#endif /* myDefines_h */
