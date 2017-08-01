//
//  WriteMailViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/31.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "WriteMailViewController.h"
#import <ChameleonFramework/Chameleon.h>


@interface WriteMailViewController ()<UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *BackBtn;
@property (weak, nonatomic) IBOutlet UIButton *KeepMessage;
@property (weak, nonatomic) IBOutlet UIButton *SendMessage;
@property (weak, nonatomic) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet UITableView *MyWriteMailTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *ToolBar;

@end

@implementation WriteMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _TextView.delegate = self;
    
    UIToolbar *test = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    test.backgroundColor = [UIColor blackColor];
//    [_TextView setInputAccessoryView:test];
    _TextView.inputAccessoryView = test;
    
    self.view.backgroundColor = [UIColor flatWhiteColorDark];
    
    // Give BackBtn a Image (Arrow38x38@2x.png).
    [_BackBtn setImage:[UIImage imageNamed:@"Arrow38x38@2x.png"]
              forState:UIControlStateNormal];
    
    // Prepare a TextView to type word for user. 準備一個 TextView 給使用者輸入文字.
    _TextView.backgroundColor=[UIColor flatSandColor];
    _TextView.font = [UIFont fontWithName:@"Arial" size:18.0];
    _TextView.textColor = [UIColor flatBlackColor];
    
    // Prepare a Time to Print. 準備一個時間顯示給 Label.
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm a"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);

    // Prepare a Label to print Date and Time. 準備Label 給 TableView 並顯示時間.
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(0, 0, _TextView.frame.size.width, 20)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = [UIColor flatGrayColor];
    label.font = [UIFont fontWithName:@"Arial" size:15];
    label.backgroundColor = [UIColor flatSandColor];
    label.text = [dateFormatter stringFromDate:[NSDate date]];
    _MyWriteMailTableView.tableHeaderView = label;
    
    _MyWriteMailTableView.backgroundColor = [UIColor flatSandColor];
    
    // Setting the NaviagtionBar BackGroundColor to CleanColor. 設定NaviagtionBar 為透明.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

- (IBAction)photoselect:(id)sender {
    
    UIActionSheet *myActionSheet =  [[UIActionSheet alloc]
                                     initWithTitle:@""
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"相簿", @"照片", nil];
    
    [myActionSheet showInView:self.view];
}


- (IBAction)backLastPage:(id)sender {
    
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        //[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
    NSLog(@"haha");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)KeepMail:(id)sender {
    
}
- (IBAction)SendMessage:(id)sender {
    
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

@end
