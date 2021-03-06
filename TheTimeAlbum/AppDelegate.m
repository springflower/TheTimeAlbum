//
//  AppDelegate.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/10.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SliderMenuViewLeft.h"
#import "MyAccountData.h"
#import "UseDownloadDataClass.h"
#import "UpdateDataView.h"
#import <AWSS3.h>
#import <Chameleon.h>

@interface AppDelegate ()
{
    MyAccountData *appCurrentUser;
    NSUserDefaults *localUserData;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[Chameleon setGlobalThemeUsingPrimaryColor: withContentStyle:(UIContentStyle)contentStyle];

    //[Chameleon setGlobalThemeUsingPrimaryColor:[UIColor flatLimeColor] withContentStyle:UIContentStyleContrast];
    // AWS 基本設定
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1 identityPoolId:@"us-east-1:e95dce68-f8c4-4c30-bd71-96d1888fefed"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    //--
    
    appCurrentUser = [MyAccountData sharedCurrentUserData];
    localUserData = [NSUserDefaults standardUserDefaults];
    
    
    
    
    // set default viewcontroller by login status
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    NSLog(@"appdele : %@", [localUserData objectForKey:@"uid"]);
    if([localUserData objectForKey:@"uid"] == nil){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"loginPage" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    
    }
    [self.window makeKeyAndVisible];
    
    
    // FB Signin
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    // 在此處加入任何自訂邏輯。
    
    // Google Signin
    NSError* configureError;
    [GIDSignIn sharedInstance].clientID = @"678118335554-5k1phchn23hvt75fn773gdf4l8l8npn8.apps.googleusercontent.com";
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    
    
    
    
    
    //pageview
    
    UIPageControl * pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //開始下載網路賶的資料
    if([[UseDownloadDataClass object] ReadSuccessUpdateBool]) {
        //        downloadChildBigSticker.hidden = false;
        //開始下載網路上儲存的資料
        UpdateDataView *downloadChildBigSticker = [UpdateDataView new];
        [downloadChildBigSticker DowloadChildBigSticker:^(NSArray *array) {
            //將成功下載的孩子大頭貼陣列資料傳到全域變數來使用
            [[UseDownloadDataClass object] PutChildBigStickerArray:array];
            //設定通知結束 SetInfoTableViewControler 進行更新
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SetInfoTableViewControler" object:nil];
            //通知執行 SliderMenuViewLeft 進行更新
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"updateTableViewContrler" object:nil];
            //設定通知結束 FutureMailViewController 進行更新
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"FutureMailViewController" object:nil];
            //下載成功後傳送 BOOL 值結束結束重複下載，如果要在執行下載必須有更新資料才會執行下載。
            [[UseDownloadDataClass object] PutSuccessUpdateBool:false];
        }];
        
    }
    
    
    
    
    
    

    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

///---------------------------------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                                  openURL:url
//                                                        sourceApplication:sourceApplication
//                                                               annotation:annotation
//                    ];
//    // 在此處加入任何自訂邏輯。
//    NSLog(@"124wesrr      %@", application);
    
    
    if ([[GIDSignIn sharedInstance] handleURL:url
                            sourceApplication:sourceApplication
                                   annotation:annotation]) {
        return YES;
    }else if([[FBSDKApplicationDelegate sharedInstance] application:application
                                                            openURL:url
                                                  sourceApplication:sourceApplication
                                                         annotation:annotation]){
        return YES;
    }
    
    return NO;
    
    
    
    
    
    
    //return handled;
}

// GOOGLE signin
//------------------
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    appCurrentUser.userGoogleId = userId;
    NSLog(@"=========UserGoogleID :%@",userId);
    NSLog(@"=========email :%@",email);
    NSLog(@"=========FullName :%@",fullName);
    //NSLog(@"=========Token :%@",idToken);
    // ...
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    if( [[GIDSignIn sharedInstance] handleURL:url
                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]){
        return YES;
    }else if([[FBSDKApplicationDelegate sharedInstance] application:app
                                                            openURL:url
                                                  sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                         annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]){
        return YES;
    }
    
    return NO;
}
@end
