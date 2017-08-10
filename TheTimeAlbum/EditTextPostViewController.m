//
//  EditTextPostViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/7.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "EditTextPostViewController.h"
#import <AFNetworking.h>
#import "MyCommunicator.h"
#import  <KVNProgress.h>

@interface EditTextPostViewController ()
{
    MyCommunicator *comm;
}
@end

@implementation EditTextPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    comm = [MyCommunicator sharedInstance];
    // Do any additional setup after loading the view.
    
    self.titleTextView.text = self.titleString;
    self.contentTextView.text = self.contentString;
    
    
    self.titleTextView.textContainer.maximumNumberOfLines = 1;
    self.titleTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog(@"--- postid: %ld", self.postID);
    [self initUI];
}

#pragma mark - 調整navigation bar item
- (void) initUI {
    
    UIBarButtonItem *rightOptionsBtn = [[UIBarButtonItem alloc] initWithTitle:@"選項"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(goOptions)];
    UIBarButtonItem *rightEditBtn = [[UIBarButtonItem alloc] initWithTitle:@"修改"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(goEditModeUI)];
    NSArray *arrayOfItems = [[NSArray alloc] initWithObjects:rightOptionsBtn,rightEditBtn, nil];
    self.navigationItem.rightBarButtonItems = arrayOfItems;
}

- (void) goEditModeUI {
    
    // About Navigation bar item    調整navigationbar item
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.rightBarButtonItems = nil;
    UIBarButtonItem *rightEditBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(doSaveChanges)];
    UIBarButtonItem *leftCancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(doCancelChanges)];
    self.navigationItem.rightBarButtonItem = rightEditBtn;
    self.navigationItem.leftBarButtonItem = leftCancelBtn;
    //--
    
    // go edit  mode   更改為修改模式
    self.contentTextView.editable = true;
    //self.contentTextView.selectedRange = NSMakeRange([self.contentTextView.text length], 0);
}

- (void) goOptions {
    
    //...
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


#pragma mark - save or cancel edited contents    存檔
- (void) doSaveChanges {
    
    //...
    NSString *editedContentString = self.contentTextView.text;

    // show progress
    [self configKVNProgress];
    [KVNProgress show];
    // go post to php and mysql and save data   通過post更新資料
    [comm updatePostsToServerWithPostID:self.postID
                                content:editedContentString
                             completion:^(NSError *error, id result) {
                                 // AFN 連線是否成功
                                 if(error){
                                     NSLog(@"updatePostsToServerWithPostID Fail: %@", error);
                                     [KVNProgress showErrorWithStatus:@"失敗 請重試"];
                                     return;
                                 }
                                 // 伺服器php指令是否成功
                                 if([result[RESULT_KEY] boolValue] == false){
                                     NSLog(@"updatePostsToServerWithPostID Fail: %@", result[ERROR_CODE_KEY]);
                                     [KVNProgress showErrorWithStatus:@"失敗 請重試"];
                                     return;
                                 }
                                 //NSArray *items = result[@"result"];
                                 NSLog(@"update post to server : %@", result[RESULT_KEY]);
                                 
                                 [KVNProgress dismissWithCompletion:^{
                                     // Things you want to do after the HUD is gone.
                                     [KVNProgress showSuccessWithStatus:@"儲存變更成功"];
                                     
                                     [self.navigationController popViewControllerAnimated:YES];
                            
                                 }];
                                 
    }];
    
    
    // 回復本來按鈕
    self.contentTextView.editable = false;
    self.navigationItem.hidesBackButton = false;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
    [self initUI];
    
}
- (void) doCancelChanges {
    
    // 回覆本來按鈕
    self.contentTextView.editable = false;
    self.navigationItem.hidesBackButton = false;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
    [self initUI];
}

#pragma  mark - default implement methods       系統方法
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

@end
