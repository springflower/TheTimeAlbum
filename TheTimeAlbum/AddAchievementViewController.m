//
//  AddAchievementViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "AddAchievementViewController.h"
#import "MyCommunicator.h"
#import <AFNetworking.h>
#import <KVNProgress.h>

@interface AddAchievementViewController ()<UITextFieldDelegate>
{
    BOOL optionMenuIsUp;
    BOOL firstTimeEdit;
    MyCommunicator *comm;
    NSUserDefaults *localUserData;
    
    NSString *babyID;
    NSString *title;
    NSString *picName;
    NSString *createDate;
}
@property (strong, nonatomic) IBOutlet UIView *myUIView;
@property (strong, nonatomic) IBOutlet UIDatePicker *myDatePicker;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabelArrow;
@property (weak, nonatomic) IBOutlet UITextField *achieveName;


@end

@implementation AddAchievementViewController

#pragma mark - 
- (void)viewWillAppear:(BOOL)animated {
    
    // 設定選項的 UIView的 Constraint
    [self.view addSubview:self.myUIView];
    self.myUIView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.myUIView.heightAnchor constraintEqualToConstant:200].active = YES;
    [self.myUIView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10].active = YES;
    [self.myUIView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10].active = YES;
    NSLayoutConstraint *c = [self.myUIView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:200];
    c.identifier = @"bottom";
    c.active = YES;
    
    [super viewWillAppear:YES];
}

- (void) callMenu {
    NSLog(@"find constraints...?");
    //ImageViewController *ivcTemp = [self.ivcs objectAtIndex:0];
    
    if (!optionMenuIsUp) {
        for (NSLayoutConstraint *c in self.view.constraints) {
            if ( [c.identifier  isEqual: @"bottom"]) {
                c.constant = -10;
                break;
            }
        }
        // 慢慢上來的動畫
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        optionMenuIsUp = YES;
    } else {
        for (NSLayoutConstraint *c in self.view.constraints) {
            if ( [c.identifier  isEqual: @"bottom"]) {
                c.constant = 128;
                break;
            }
        }
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        optionMenuIsUp = NO;
    }
}

- (void) closeMenu {
    
    if (optionMenuIsUp){
        
        for (NSLayoutConstraint *c in self.view.constraints) {
            if ( [c.identifier  isEqual: @"bottom"]) {
                c.constant = 200;
                break;
            }
        }
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        optionMenuIsUp = NO;
    }
    
}


- (void) initUI {
    
    
    
    
    // 成就名稱的 textfield 設定
    [self.achieveName setReturnKeyType:UIReturnKeyDone];
    self.achieveName.clearsOnBeginEditing = YES;
    self.achieveName.delegate = self;

    // 放圖片
    self.achievementImage.contentMode = UIViewContentModeScaleAspectFit;
    self.achievementImage.image = self.thisImage;
    
    // 放日期label 設定
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年M月d日";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    self.dateLabel.text = dateString;
    
    // 讓日期label點下去可以叫選單
    self.dateLabel.userInteractionEnabled = YES;
    self.dateLabelArrow.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(beginToPickDate)];
    [self.dateLabel addGestureRecognizer:tapGesture];
    [self.dateLabelArrow addGestureRecognizer:tapGesture];
    
    // navigation bar 顏色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems.firstObject.tintColor = [UIColor blackColor];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    //放navbar item
    UIBarButtonItem *rightCompleteBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(onCompleteAddAchievement)];
    //NSArray *arrayOfItems = [[NSArray alloc] initWithObjects:rightOptionsBtn,rightEditBtn, nil];
    self.navigationItem.rightBarButtonItem = rightCompleteBtn;
}
//  ================ VIEWDIDLOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化 物件參數
    optionMenuIsUp = NO;
    firstTimeEdit = YES;
    comm = [MyCommunicator sharedInstance];
    localUserData = [NSUserDefaults standardUserDefaults];
    
    
    // 初始化 設定頁面元件
    [self initUI];
    
    
    // 監聽datePicker選擇變化 (沒用到)
    [self.myDatePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self prepareForAdding];
    
}

- (void)prepareForAdding {

    babyID = [localUserData objectForKey:@"babyid"];
    title = self.achieveName.text;
    picName = self.thisPicName;
    createDate = self.dateLabel.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - KVN的讀取條

- (void) configKVNProgress {
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self.view endEditing:NO];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.achieveName resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.achieveName resignFirstResponder];
    //[self.achieveName clearsOnBeginEditing] = NO;
    return YES;
}




#pragma mark - 選日期
- (IBAction)onDatePickComfirmed:(UIButton *)sender {
    
    //创建一个日期格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //设置日期的显示格式
    fmt.dateFormat = @"yyyy年M月d日";
    //将日期转为指定格式显示
    NSString *dateStr = [fmt stringFromDate:self.myDatePicker.date];
    _dateLabel.text = dateStr;
    //optionMenuIsUp = NO;
    [self closeMenu];
    
}
- (IBAction)onDatePickCanceled:(UIButton *)sender {
    [self closeMenu];
}
- (void)beginToPickDate {
    
    [self callMenu];
}

- (void)valueChange:(UIDatePicker *)datePicker{
    
}


#pragma mark - 新增成就完成或取消

- (void)onCompleteAddAchievement {
    
    [self prepareForAdding];
    
    // show progress
    [self configKVNProgress];
    [KVNProgress show];
    //go post to php and mysql and save data   通過post更新資料
    
    
    [comm addAchievementForbabyID:babyID
                            title:title
                          picName:picName
                       createDate:createDate
                       completion:^(NSError *error, id result) {
                           
                           // AFN 連線是否成功
                           if(error){
                               NSLog(@"addAchievementForbabyID AFN Fail: %@", error);
                               [KVNProgress showErrorWithStatus:@"失敗 請重試"];
                               return;
                           }
                           // 伺服器php指令是否成功
                           if([result[RESULT_KEY] boolValue] == false){
                               NSLog(@"addAchievementForbabyID php Fail: %@", result[ERROR_CODE_KEY]);
                               [KVNProgress showErrorWithStatus:@"失敗 請重試"];
                               return;
                           }
                           
                           NSLog(@"新增成就成功");
                           [KVNProgress showSuccessWithStatus:@"新增成就成功"];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"NewAchievementAdded" object:nil];
                           
                           [self.navigationController popViewControllerAnimated:YES];
                       }];
}

- (void)onCancelAddAchievement {
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
