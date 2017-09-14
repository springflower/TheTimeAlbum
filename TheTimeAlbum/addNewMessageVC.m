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
#import "UITextView+YLTextView.h"

@interface addNewMessageVC () <UITextViewDelegate>
{
    MyCommunicator *comm;
    NSUserDefaults *localUserData;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation addNewMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    comm = [MyCommunicator sharedInstance];
    localUserData = [NSUserDefaults standardUserDefaults];
    
    
    [self initKeyboard];
    
}


- (void) initKeyboard {
    
    //NSString *date = [NSString stringWithFormat:@"%@", [NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年M月d日";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    self.titleLabel.text = dateString;
    
    //[self.contentText setFont:[UIFont systemFontOfSize:19.0]];
    self.contentText.tag = 1001;
    self.contentText.returnKeyType = UIReturnKeyDefault; // 下一行
    self.contentText.delegate = self;
    
    
    self.contentText.text = @"";
    self.contentText.placeholder = @"記錄下今天的心情吧...";
    self.contentText.limitLength = @200;
    self.contentText.limitLines = @14;//行数限制优先级低于字数限制
   // [self.view addSubview:textView];
    
    
    
    // 2、键盘上方附加一个toolbar，toolbar上有个完成按钮
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil]; // 让完成按钮显示在右侧
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(pickerDoneClicked)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    self.contentText.inputAccessoryView = keyboardDoneButtonView;
    
    
    //[self.view addSubview:tv];
}

-(void)pickerDoneClicked
{
    UITextView* view = (UITextView*)[self.view viewWithTag:1001];
    [view resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// FIXME: add uid to post
- (IBAction)saveBtnPressed:(id)sender {
    NSString *babyID = [localUserData objectForKey:@"babyid"];
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
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"doReloadJob" object:nil];
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
