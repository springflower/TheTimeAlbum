//
//  loginViewController.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface loginViewController : UIViewController <GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

