//
//  addNewMessageVC.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/24.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "addNewMessageVC.h"
#import <AFNetworking.h>
#import "myDefines.h"
#import "MyCommunicator.h"
#import <KVNProgress.h>


@interface addNewMessageVC ()
{
    MyCommunicator *comm;
}

@end

@implementation addNewMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    comm = [MyCommunicator sharedInstance];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// FIXME: add uid to post
- (IBAction)saveBtnPressed:(id)sender {
    NSString *babyID = @"1";
    NSString *content = self.contentText.text;
    NSString *postType = @"1";
    
    // show progress
    [self configKVNProgress];
    [KVNProgress show];
    
    [comm sendTextMessage:content
                forbabyID:babyID
                 postType:postType
               completion:^(NSError *error, id result) {
                   if(error){
                       NSLog(@"Do sendTextMessage fail: %@", error);
                       [KVNProgress showErrorWithStatus:@"失敗 請重試"];
                       return;
                   }
                   NSLog(@"==--%@", result);
                   // 伺服器php指令是否成功
                   if([result[RESULT_KEY] boolValue] == false){
                       NSLog(@"Update textMessage to sql failed: %@", result[ERROR_CODE_KEY]);
                       [KVNProgress showErrorWithStatus:@"失敗 請重試"];
                       return;
                   }
                   
                   [KVNProgress dismissWithCompletion:^{
                       // Things you want to do after the HUD is gone.
                       [KVNProgress showSuccessWithStatus:@"新增成功"];
                       
                       [self.navigationController popViewControllerAnimated:YES];
                       
                   }];
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
    configuration.fullScreen = NO;
    configuration.showStop = NO;
    configuration.stopRelativeHeight = 0.4f;
    
    configuration.tapBlock = ^(KVNProgress *progressView) {
        [self.navigationController popViewControllerAnimated:YES];
    };
    configuration.allowUserInteraction = NO;
    [KVNProgress setConfiguration:configuration];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
