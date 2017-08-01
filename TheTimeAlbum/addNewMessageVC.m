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
    
    
    [comm sendTextMessage:content
                forbabyID:babyID
                 postType:postType
               completion:^(NSError *error, id result) {
                   if(error){
                       NSLog(@"Do sendTextMessage fail: %@", error);
                                          return;
                   }
                   NSLog(@"==--%@", result);
                   // 伺服器php指令是否成功
                   if([result[RESULT_KEY] boolValue] == false){
                       NSLog(@"Update textMessage to sql failed: %@", result[ERROR_CODE_KEY]);
                       return;
                   }
    }];
    [self.navigationController popViewControllerAnimated:YES];
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
