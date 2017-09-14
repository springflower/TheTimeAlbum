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
#import "UpdateDataView.h"
#import <KVNProgress.h>
#import <AWSS3.h>

@interface loginViewController () <FBSDKLoginButtonDelegate, GIDSignInDelegate,GIDSignInUIDelegate>
{
    NSString    *userName;      // Get it from facebook api.    從FB登入資訊取得
    NSString    *userMail;      // Get it from facebook api.    從FB登入資訊取得
    NSURL       *picUrl;        // Get it from facebook api.    從FB登入資訊取得
    NSData      *userImage;     // temperary not used.  暫時沒用
    NSString    *theurl;        // Url to write or get user data from sql server.  更新或寫入帳號資訊的網址
    NSString    *userId;        // Will get it from server by sql. 從SQL資料庫以fb或google id取得
    NSUserDefaults *localUserData;
    NSMutableArray *incomingPosts;
    
    MyAccountData *currentuser;
    MyCommunicator *comm;
    
    
    NSMutableArray *incomingBabyNames;
    NSMutableArray *incomingBabyDateStrings;
    NSMutableArray *incomingBabyPics;
    NSMutableArray *incomingBabyIDs;
    
    
    //FIXME: temp
    //準備讀取孩子名字陣列
    NSMutableArray *putChildTextFieldnameArray;
    //準備讀取孩子生日陣列
    NSMutableArray *putChildBirthdayFieldArray;
    //準備讀取儲存的個人信件數量
    NSMutableArray *putDateArray;
    //準備讀取儲存的個人信件內容數量
    NSMutableArray *putTextViewArray;
    //準備讀取孩子性別陣列
    NSMutableArray *putChildSexArray;
    //準備讀取與孩子的關係陣列
    NSMutableArray *putWithChildRelationShipArray;
    //準備讀取孩子的背景陣列
    NSMutableArray *putMyChildBackImageArray;
    //準備讀取孩子的性別選項
    NSInteger ChildSex;
    //準備讀取與孩子的關係選項
    NSInteger WithRelationship;
    //準備讀取儲存的資料
    NSUserDefaults *defaults;
    //準備 Frame
    CGRect fullScreenBounds;
    //準備 datePicker
    UIDatePicker *datePicker;
    
    UITableView * testtable;
    //準備結束 AddChildSettingViewController
    BOOL Dismiss;
    //準備取消按鈕
    UIBarButtonItem *CancelBtn;
    
    NSInteger ChildID;
    // end of temp
    
}
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UIWebView *webViewBG;

@end

@implementation loginViewController

- (void) someSettings {
    //讀取是否已有建立第一個孩子 Name.
    NSUserDefaults *readChildIdDefaults;
    readChildIdDefaults = [NSUserDefaults standardUserDefaults];
    //如果讀出的陣列數量為零的話，就執行 AddChildSettingViewController 來創造第一個孩子。
    NSArray *readChildNameArray = [readChildIdDefaults objectForKey:@"ChildName"];
    if(readChildNameArray.count == 0) {
        CancelBtn.enabled = false;
    } else {
        CancelBtn.enabled = true;
    }
    //讀取孩子的名稱陣列
    NSArray *readChildTextFieldnameArray = [defaults objectForKey:@"ChildName"];
    if(readChildTextFieldnameArray.count != 0) {
        putChildTextFieldnameArray  = [readChildTextFieldnameArray mutableCopy];
    } else {
        putChildTextFieldnameArray = [NSMutableArray new];
    }
    //讀取孩子的生日陣列
    NSArray *readChildBirthdayFieldArray = [defaults objectForKey:@"ChildBirthday"];
    if(readChildBirthdayFieldArray.count != 0) {
        putChildBirthdayFieldArray  = [readChildBirthdayFieldArray mutableCopy];
    } else {
        putChildBirthdayFieldArray = [NSMutableArray new];
    }
    //讀取孩子的個人信件陣列
    NSArray *readDateArray = [defaults objectForKey:@"Mailibformation"];
    if(readDateArray.count != 0) {
        putDateArray  = [readDateArray mutableCopy];
    } else {
        putDateArray = [NSMutableArray new];
    }
    //讀取孩子的個人信件內容陣列
    NSArray *readTextViewArray = [defaults objectForKey:@"textViewcontent"];
    if(readTextViewArray.count != 0) {
        putTextViewArray  = [readTextViewArray mutableCopy];
    } else {
        putTextViewArray = [NSMutableArray new];
    }
    //讀取孩子的性別陣列
    NSArray *readChildSexArray = [defaults objectForKey:@"readChildSexArray"];
    if(readChildSexArray.count != 0) {
        putChildSexArray = [readChildSexArray mutableCopy];
    } else {
        putChildSexArray = [NSMutableArray new];
    }
    //讀取與孩子的關係陣列
    NSArray *readWithChildRelationShipArray = [defaults objectForKey:@"readWithChildRelationShipArray"];
    if(readWithChildRelationShipArray.count != 0) {
        putWithChildRelationShipArray = [readWithChildRelationShipArray mutableCopy];
    } else {
        putWithChildRelationShipArray = [NSMutableArray new];
    }
    //準備讀取儲存的孩子背景圖片陣列
    NSArray *readMyChildBackImageArray = [defaults objectForKey:@"readMyChildBackImageArray"];
    if(readMyChildBackImageArray) {
        putMyChildBackImageArray  = [readMyChildBackImageArray mutableCopy];
    } else {
        putMyChildBackImageArray = [NSMutableArray new];
    }
    
    //判斷當 BigStickerSettingViewControler 按下完成後，就結束 AddChildSettingViewControler.
    if (Dismiss == true) {
        Dismiss = false;
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    incomingBabyIDs = [NSMutableArray new];
    incomingBabyNames = [NSMutableArray new];
    incomingBabyDateStrings = [NSMutableArray new];
    incomingBabyPics = [NSMutableArray new];
    [defaults synchronize];
    


}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialBG];
    
    [self someSettings];
    
    [self configKVNProgress];
    
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
    incomingPosts = [NSMutableArray new];
    
    
    _loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_photos"];
    _loginButton.delegate = self;
    
    
    // Google login delegate                            Google 登入
    [GIDSignIn sharedInstance].uiDelegate = self;
    //--
    
    
}
//FIXME: 要做成先跑動畫 等UID抓到 再抓babydata 抓完後 當所有東西都好了 才去下一頁
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
                 
                 //return;
             }else {
                 NSLog(@"** No need to Register **");
                 NSLog(@"currentuser.uid: %@",currentuser.userId);
                 currentuser.userId = result1[@"uid"];
                 NSLog(@"currentuser.uid: %@",currentuser.userId);
                 [localUserData setObject:currentuser.userId forKey:@"uid"];
                 
                 
                 
                 // 用UID抓取 小孩們
                 [self getBabyData];
                 
                 //FIXME: 要做成先跑動畫 當所有東西都好了 才去下一頁
                 // 取得uid後  才去下一頁
                 //[self goNextPage];
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

- (void) initialBG {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"WebViewContent" ofType:@"html"];
    NSURL *htmlURL = [[NSURL alloc] initFileURLWithPath:htmlPath];
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:htmlURL];
    
    [self.webViewBG loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[htmlURL URLByDeletingLastPathComponent]];
    

    
    
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    //filter.backgroundColor = [UIColor blackColor];
    //filter.alpha = 0.4;
    filter.translatesAutoresizingMaskIntoConstraints = NO;
    
    CAGradientLayer *layer = [CAGradientLayer layer];;
    layer.frame = filter.bounds;
    
    NSArray *colors = [NSArray arrayWithObjects: (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] CGColor],nil];
    [layer setColors:colors];
    [filter.layer insertSublayer:layer atIndex:0];
    
    
    
    
    [self.view insertSubview:filter aboveSubview:_webViewBG];
    
    
    
    
}


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
                         [comm getUIDFromSQLByFBID:currentuser.userFBId
                                        completion:^(NSError *error, id result) {
                                            currentuser.userId = result[@"uid"];
                                            [localUserData setObject:result[@"uid"] forKey:@"uid"];
                                            NSLog(@"註冊後找回的uid: %@",currentuser.userId);
                                            [self getBabyData];
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

#pragma mark - 取得寶寶資料

//FIXME: 尚未實作從SQL撈babydata 存入Userdefaults
- (void) getBabyData {
    NSString *localUID = [localUserData objectForKey:@"uid"];
    
    
    [comm getBabyDataByUID:localUID
                completion:^(NSError *error, id result) {
                    // AFN 連線是否成功
                    if(error){
                        NSLog(@"** getBabyDataByUID Fail: %@", error);
                        //[self doReloadJob];
                        return;
                    }
                    // 伺服器php指令是否成功
                    if([result[RESULT_KEY] boolValue] == false){
                        NSLog(@"** getBabyDataByUID Fail: %@", result[ERROR_CODE_KEY]);
                        //[self doReloadJob];
                        return;
                    }
                    //取回來的 寶寶們的 陣列
                    NSArray *items = result[@"BabysArr"];
                    NSLog(@"Receive babys number: %lu", items.count);
                    
                    // 如果名下都沒有寶寶
                    if(items.count == 0){
                        NSLog(@"No baby , do nothing and return.");
                        // 做些什麼
                        [KVNProgress dismiss];
                        [self goNextPage];
                        return;
                    }
                    //[getAchievementItems removeAllObjects];
                    
                    
                    // Handle new messages
                    [incomingPosts addObjectsFromArray:items];
                    NSLog(@"** do before getBabyData");
                    [self handleIncomingBabys:items.count];
                    NSLog(@"** done with getBabyData");
                    
                    
                    
                    //準備下載信件資料
                    UpdateDataView *downloadMailContent = [UpdateDataView new];
                    [downloadMailContent DownloadFutureMailContent];
                    
                    
                    [KVNProgress dismiss];
                    [self goNextPage];
                    
                }];
}

-(void) handleIncomingBabys: (NSInteger) howManyPosts{
    //Exit when there is no more message need to be handled.
    if(incomingPosts.count == 0){
        return;
    }
    // 暫存的 總共有幾個post 用來幫助postitem存indexpath
    NSInteger postNumTotal = howManyPosts;
    NSInteger reducingPostsNum = incomingPosts.count;
    NSInteger itemIndex = postNumTotal-reducingPostsNum;
    NSLog(@"= = = the indexpath : %ld", itemIndex);
    
    
    NSDictionary *tmp = incomingPosts.firstObject;
    
    
    
    // Parse all fields of each message.
    //將NSDictionary中的NSNumber 轉成 NSInteger
    // 如果是一開始登入時 取回的是寶寶資料
    NSInteger babyID = [tmp[@"babyID"] integerValue];
    NSString *babyName = tmp[@"babyName"];
    NSString *dateString = tmp[@"birthday"];
    NSString *babyPic = tmp[@"babyPic"];
    
    NSLog(@" got babyID: %ld, babyName: %@, dateString: %@, babyPic: %@", babyID, babyName, dateString, babyPic);
    
    [self downloadBabyPicifNeeded:babyPic];
    //將取回的日期轉成NSDate
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate  *date = [gmtDateFormatter dateFromString:dateString];
    NSLog(@"-- date :%@", date);
    
    [incomingBabyNames addObject:babyName];
    [incomingBabyDateStrings addObject:dateString];
    [incomingBabyPics addObject:babyPic];
    [incomingBabyIDs addObject:@(babyID)];
    
    if (howManyPosts == incomingPosts.count) {
        //  暫存第一個baby的資料作為預設寶寶
        [localUserData setObject: [NSString stringWithFormat:@"%ld",babyID] forKey:@"babyid"];
        [localUserData setObject:babyName forKey:@"currentBabyName"];
        [localUserData setObject:date forKey:@"currentBabyBirthday"];
        [localUserData setObject:babyPic forKey:@"currentBabyPic"];
        [localUserData setInteger:0 forKey:@"currentBabyIndex"];
        
        
        //"childNames"];
        //childBirthdays = [localUserData objectForKey:@"childBirthdays"];
        //childPics = [localUserData objectForKey:@"childPics"];
        // 寶寶資料
        
        
    }
    NSLog(@" incoming posts...: %ld", incomingPosts.count);
    if (incomingPosts.count == 1 ) {
        
        [localUserData setObject:incomingBabyNames forKey:@"childNames"];
        [localUserData setObject:incomingBabyDateStrings forKey:@"childBirthdays"];
        [localUserData setObject:incomingBabyPics forKey:@"childPics"];
        [localUserData setObject:incomingBabyIDs forKey:@"childIDs"];
        
        NSLog(@" (handle baby) names: %@, bir: %@, pics: %@, ids: %@",
              [localUserData objectForKey:@"childNames"],
              [localUserData objectForKey:@"childBirthdays"],
              [localUserData objectForKey:@"childPics"],
              [localUserData objectForKey:@"childIDs"] );
        [incomingBabyNames removeAllObjects];
        [incomingBabyDateStrings removeAllObjects];
        [incomingBabyPics removeAllObjects];
        [incomingBabyIDs removeAllObjects];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"reloadLeftMenu" object:nil];
    }
    
    NSLog(@" 存default的 babyID: %@, 寶名: %@, 生日: %@, 圖: %@", [localUserData objectForKey:@"babyid"], [localUserData objectForKey:@"currentBabyName"] , [localUserData objectForKey:@"currentBabyBirthday" ], [localUserData objectForKey:@"currentBabyPic"]);
    
    [incomingPosts removeObjectAtIndex:0];
    [self handleIncomingBabys: howManyPosts];
}

///==============
- (void) downloadBabyPicifNeeded:(NSString*) babyPic {
    
    NSString *downloadingFilePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"userPic"] stringByAppendingPathComponent:babyPic];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    
    
    // 檢查圖片是否已暫存 是的話就不下載
    NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userPic"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSArray * a = [fileM contentsOfDirectoryAtPath:directory error:nil];
    for(NSString *temp in a){
        
        NSLog(@"......  : %@", temp);
        if([babyPic isEqualToString: temp]){
            NSLog(@"- - 用戶大頭已存在: %@", temp);
            NSData *currentUserPic = [NSData dataWithContentsOfURL:downloadingFileURL];
            [localUserData setObject:currentUserPic forKey:@"CurrentUserPic"];
            return;
        }
    }
    
    
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new ];
    downloadRequest.bucket = @"the.timealbum";
    downloadRequest.key = babyPic;
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    [[transferManager download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id _Nullable(AWSTask * _Nonnull task) {
        if(task.error){
            
            NSLog(@" 使用者大頭下載錯誤");
        }
        
        if (task.result) {
            // 印出本地下載暫存路徑中的檔案名稱
            NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userPic"];
            NSFileManager *fileM = [NSFileManager defaultManager];
            NSArray * a = [fileM contentsOfDirectoryAtPath:directory error:nil];
            for(NSString *temp in a){
                NSLog(@"- - temp in userPic: %@", temp);
            }
            //NSLog(@"%@", task.result);
            
            //AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
            NSLog(@" - - - - 使用者大頭 download success....");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBabyPicNamePost" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLeftMenu" object:nil];
            
        }
        return nil;
    }];
}

- (void) configKVNProgress {
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    //configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    //    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    //    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    //    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    //    configuration.errorColor = [UIColor whiteColor];
    //    configuration.stopColor = [UIColor whiteColor];
    configuration.circleSize = 110.0f;
    configuration.lineWidth = 1.0f;
    configuration.fullScreen = YES;
    configuration.showStop = NO;
    configuration.stopRelativeHeight = 0.4f;
    
    configuration.tapBlock = ^(KVNProgress *progressView) {
        [self.navigationController popViewControllerAnimated:YES];
    };
    configuration.allowUserInteraction = NO;
    [KVNProgress setConfiguration:configuration];
}


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
            [KVNProgress show];
            [self getFBUserData];
        }
        NSLog(@"****** FB did complete with Login 2 ******");
        //[self getFBUserData];];
        //[self goNextPage];
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    //... clean userdefaults
    
    NSDictionary *dictionary = [localUserData dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        [localUserData removeObjectForKey:key];
        [localUserData synchronize];
    }
}
//--


-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {

}

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
