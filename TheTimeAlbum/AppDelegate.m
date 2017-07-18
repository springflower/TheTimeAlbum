//
//  AppDelegate.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/10.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // FB Signin
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    // 在此處加入任何自訂邏輯。
    
    // Google Signin
    NSError* configureError;
    [GIDSignIn sharedInstance].clientID = @"678118335554-5k1phchn23hvt75fn773gdf4l8l8npn8.apps.googleusercontent.com";
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
    NSLog(@"=========email :%@",userId);
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
