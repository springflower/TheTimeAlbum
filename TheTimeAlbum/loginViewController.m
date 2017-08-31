//
//  loginViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "loginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MyAccountData.h"
#import "ThisBabyData.h"
#import <AFNetworking.h>
#import "MyCommunicator.h"
#import "timeLineVC.h"

@interface loginViewController () <FBSDKLoginButtonDelegate>
{
    NSString    *userName;      // Get it from facebook api.    從FB登入資訊取得
    NSString    *userMail;      // Get it from facebook api.    從FB登入資訊取得
    NSURL       *picUrl;        // Get it from facebook api.    從FB登入資訊取得
    NSData      *userImage;     // temperary not used.  暫時沒用
    NSString    *theurl;        // Url to write or get user data from sql server.  更新或寫入帳號資訊的網址
    NSString    *userId;        // Will get it from server by sql. 從SQL資料庫以fb或google id取得
    NSUserDefaults *localUserData;
    
    MyAccountData *currentuser;
    MyCommunicator *comm;
}
@property (weak, nonatomic) IBOutlet UIImageView *userPic;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // user default
    localUserData = [NSUserDefaults standardUserDefaults];
    NSString *localUID = [localUserData objectForKey:@"uid"];
    NSString *localUserName = [localUserData objectForKey:@"userName"];
    NSString *localUserMail = [localUserData objectForKey:@"userMail"];
    NSData *localUserImage = [localUserData dataForKey:@"userImage"];
    NSLog(@"local UID: %@, localname: %@, local mail: %@, local image: %@", localUID, localUserName,localUserMail, localUserImage);
    //--
    
    
    // Init singleton variables.        初始化singleton變數
    currentuser = [MyAccountData sharedCurrentUserData];
    comm = [MyCommunicator sharedInstance];
    //--
    
    
    
    _loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_photos"];
    _loginButton.delegate = self;
    
    
    
    // Google login delegate                            Google 登入
    [GIDSignIn sharedInstance].uiDelegate = self;
    //--
    
}
// Get user data form  facebook         取得ＦＢ使用者的資料
- (void) getFBUserData {
    
    // get user data from facebook graph-api            透過fb graph-api 取得使用者ＦＢ上的資料
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,gender,picture.type(large)" forKey:@"fields"];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         
         NSLog(@"%@",result);
         userId = [result objectForKey:@"id"];
         NSLog(@"2retgdhggfdgdf   %@",userId);
         
         // singleton method to save user data from facebook    取得FB用戶資料
         //currentuser.userId = [result objectForKey:@"id"];
         currentuser.userMail = [result objectForKey:@"email"];
         currentuser.gender = [result objectForKey:@"gender"];
         currentuser.userName = [result objectForKey:@"name"];
         currentuser.userPic = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
         currentuser.userFBId = [result objectForKey:@"id"];
         //--
         
         // test
         NSLog(@"id: %@, mail: %@, gender: %@, name: %@, url: %@, fbid: %@, gid: %@", currentuser.userId, currentuser.userMail, currentuser.gender, currentuser.userName, currentuser.userPic, currentuser.userFBId, currentuser.userGoogleId);
         //--
         
         // 放大頭
         NSURL *url = [NSURL URLWithString:currentuser.userPic];
         NSData *data = [NSData dataWithContentsOfURL:url];
         UIImage *img = [[UIImage alloc] initWithData:data];
         dispatch_async(dispatch_get_main_queue(), ^{
             [_userPic setImage:img];
         });
         //--
         
         // save get user data to userdefault   將取到的資料存到userdefault
         [localUserData setObject:currentuser.userName forKey:@"userName"];
         [localUserData setObject:currentuser.userMail forKey:@"userMail"];
         [localUserData setObject:data forKey:@"userImage"];
         [localUserData synchronize];

         //--
         // get uid from SQL server         用fb登入資訊從SQL資料庫抓uid
         [comm getUIDFromSQLByFBID:currentuser.userFBId completion:^(NSError *error, id result1) {
             
             
             //currentuser.userId = [self htmlEntityDecode:currentuser.userId];
             //NSLog(@"currentuser.uid: %@",currentuser.userId);
             
             
             
             if([result1[@"uid"] isEqualToString:@""]) {
                 NSLog(@"** GO Register **");
                 [self registerToSQL: currentuser];
                 return;
             }else {
                 NSLog(@"** No need to Register **");
                 NSLog(@"currentuser.uid: %@",currentuser.userId);
                 currentuser.userId = result1[@"uid"];
                 NSLog(@"currentuser.uid: %@",currentuser.userId);
                 [localUserData setObject:currentuser.userId forKey:@"uid"];
             }
             
             if(error){
                 NSLog(@"[Method fail] getUIDFromSQLByFBID FAIL: %@", error);
                 NSLog(@"=====%@", result1);
                 return;
             }
             // 伺服器php指令是否成功
             if([result1[RESULT_KEY] boolValue] == false){
                 NSLog(@"Get UID by FBID Fail: %@", result1[ERROR_CODE_KEY]);
                 return;
             }
         }];
         
        

         //[self goNextPage];
         [localUserData synchronize];

     }];
}
//--

-(void)viewWillAppear:(BOOL)animated {
    // If facebook is logging in do something    如果用戶已登入且，執行前往下一個VC之類的操作。
    localUserData = [NSUserDefaults standardUserDefaults];
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSLog(@"**** viewWillAppear & logined ****");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goNextPage];
        });
        NSLog(@"oo uid: %@", [localUserData objectForKey:@"uid"]);
    }
    //--
    NSLog(@"**** viewWillAppear & not login ****");
    NSLog(@"ooo uid: %@", [localUserData objectForKey:@"uid"]);
}
//--

// Go to main page.                         去首頁
- (void) goNextPage {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    timeLineVC *tlvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];

    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:tlvc];
    //[self.navigationController pushViewController:tlvc animated:YES];
    //[self presentViewController:tlvc animated:YES completion:nil];
    [self presentViewController:[viewControllers firstObject] animated:YES completion:nil];

    
}
//--

-(void) registerToSQL:(MyAccountData*) currentUser {
    // Save or update user data to SQL.        將使用者資料存入或更新至SQL
    [comm registerUserToSQL:currentuser
                 completion:^(NSError *error, id result) {
                     if(error){
                         NSLog(@"[Method fail] registerUserToSQL FAIL: %@", error);
                         return;
                     }
                     NSLog(@"===== register user to sql:%@", result[RESULT_KEY]);
                     
                     if([result[RESULT_KEY] boolValue] == true){
                         [comm getUIDFromSQLByFBID:currentuser.userFBId completion:^(NSError *error, id result) {
                             currentuser.userId = result[@"uid"];
                             [localUserData setObject:result[@"uid"] forKey:@"uid"];
                             NSLog(@"註冊後找回的uid: %@",currentuser.userId);
                         }];
                     }
                     // 伺服器php指令是否成功
                     if([result[RESULT_KEY] boolValue] == false){
                         NSLog(@"Update user to SQL Fail: %@", result[ERROR_CODE_KEY]);
                         return;
                     }
                 }];
    //--
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//--
//      FB login button delegate.               臉書登入按鈕委派的功能
#pragma mark - FBLoginButton Delegate method
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    NSLog(@"***** login result : %@", result.isCancelled ? @"is cancelled" : @"is not cancelled");
    if(error){
        //...
        return;
    } else {
        NSLog(@"===== uid:%@", [localUserData objectForKey:@"uid"]);
        if([localUserData objectForKey:@"uid"]==nil){
            NSLog(@"****** FB did complete with Login 1 ******");
            [self getFBUserData];
        }
        NSLog(@"****** FB did complete with Login 2 ******");
        //[self getFBUserData];];
        [self goNextPage];
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    //... clean userdefaults
}
//--


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Google Logout Button IBOutlet                Google 登出的動作
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}
//--

@end
