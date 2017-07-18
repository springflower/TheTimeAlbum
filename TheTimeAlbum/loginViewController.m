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

@interface loginViewController ()
{
    NSString    *userName;
    NSString    *userMail;
    NSURL       *picUrl;
    UIImage     *userImage;
    NSString    *theurl;
    NSString    *userId;
}
@property (weak, nonatomic) IBOutlet UIImageView *userPic;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // if facebook is logging in go next page       如果用戶已登入，執行前往下一個檢視控制器之類的操作。
    }
    
    _loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_photos"];
    
    // get user data from facebook graph-api            透過fb graph-api 取得使用者ＦＢ上的資料
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         
         NSLog(@"%@",result);
         userId = [result objectForKey:@"id"];
         NSLog(@"2retgdhggfdgdf   %@",userId);
         
         NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",userId];
         NSLog(@"%@", urlString);
         NSURL *url = [NSURL URLWithString:urlString];
         NSData *data = [NSData dataWithContentsOfURL:url];
         UIImage *img = [[UIImage alloc] initWithData:data];
         dispatch_async(dispatch_get_main_queue(), ^{
             [_userPic setImage:img];
         });
     
     }];
    //-----------------------------------------------------------------------------------
    
    // Google login delegate                            Google 登入
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
