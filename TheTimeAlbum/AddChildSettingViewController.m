//
//  AddChildSettingViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "AddChildSettingViewController.h"
#import "BigStickerSettingViewController.h"

@interface AddChildSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *BoySelected;
@property (weak, nonatomic) IBOutlet UIButton *GirlSelected;
@property (weak, nonatomic) IBOutlet UIButton *AnotherSelected;
@property (weak, nonatomic) IBOutlet UIButton *FatherSelected;
@property (weak, nonatomic) IBOutlet UIButton *MotherSelected;
@property (weak, nonatomic) IBOutlet UIButton *AnotherRelationship;
@property (weak, nonatomic) IBOutlet UITextField *MyName;
@property (weak, nonatomic) IBOutlet UITextField *BirthdayTextField;
@end

@implementation AddChildSettingViewController
{
    CGRect fullScreenBounds;
    UIDatePicker *datePicker;
    UITableView * testtable;
}
@synthesize MyName = MyName;
@synthesize BirthdayTextField = BirthdayTextField;
@synthesize BoySelected = BoySelected;
@synthesize GirlSelected = GirlSelected;
@synthesize AnotherSelected = AnotherSelected;


- (IBAction)NameTextField:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    
    self.navigationItem.title = @"設定";
    
    [self SettingChildNameAndBirthday];
    
    [self SettingChildGender];
    
    // Prepare the Button add to NavigationBar.
    UIBarButtonItem *NextStep = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:
                                 UIBarButtonItemStyleDone target:self action:@selector(NextStepToSettingBigStickers)];
    self.navigationItem.rightBarButtonItem = NextStep;
    UIBarButtonItem *Cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:
                                UIBarButtonItemStyleDone target:self action:@selector(CancelAddChildSettingViewController)];
    self.navigationItem.leftBarButtonItem = Cancel;
    
    
    _FatherSelected.layer.cornerRadius=15.0;
    _FatherSelected.layer.borderWidth = 1.0;
    _FatherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_BoySelected.backgroundColor = [UIColor lightGrayColor];
    [_FatherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _FatherSelected.tintColor = [UIColor grayColor];
    
    _MotherSelected.layer.cornerRadius=15.0;
    _MotherSelected.layer.borderWidth = 1.0;
    _MotherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_BoySelected.backgroundColor = [UIColor lightGrayColor];
    [_MotherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _MotherSelected.tintColor = [UIColor grayColor];
    
    _AnotherRelationship.layer.cornerRadius=15.0;
    _AnotherRelationship.layer.borderWidth = 1.0;
    _AnotherRelationship.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_BoySelected.backgroundColor = [UIColor lightGrayColor];
    [_AnotherRelationship setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _AnotherRelationship.tintColor = [UIColor grayColor];
    
    
    testtable = [[UITableView alloc] initWithFrame:CGRectMake(0,50,100,150)];
    [testtable setDataSource:self];
    [testtable setDelegate:self];
//  _AnotherRelationship.inputAccessoryView= testtable;
    
//    yourpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
//    [yourpicker setDataSource: self];
//    [yourpicker setDelegate: self];
//    yourpicker.showsSelectionIndicator = YES;
//    self.yourtextfield.inputView = yourpicker;
    
    
}

- (IBAction)BoySelected:(id)sender {
    BoySelected.layer.borderColor = [UIColor blueColor].CGColor;
    BoySelected.tintColor = [UIColor blueColor];
    [BoySelected setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    GirlSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    GirlSelected.tintColor = [UIColor grayColor];
    [GirlSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    AnotherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    AnotherSelected.tintColor = [UIColor grayColor];
    [AnotherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (IBAction)GirlSelected:(id)sender {
    GirlSelected.layer.borderColor = [UIColor blueColor].CGColor;
    GirlSelected.tintColor = [UIColor blueColor];
    [GirlSelected setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    BoySelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    BoySelected.tintColor = [UIColor grayColor];
    [BoySelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    AnotherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    AnotherSelected.tintColor = [UIColor grayColor];
    [AnotherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (IBAction)AnotherSelected:(id)sender {
    AnotherSelected.layer.borderColor = [UIColor blueColor].CGColor;
    AnotherSelected.tintColor = [UIColor blueColor];
    [AnotherSelected setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    BoySelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    BoySelected.tintColor = [UIColor grayColor];
    [BoySelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    GirlSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    GirlSelected.tintColor = [UIColor grayColor];
    [GirlSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (IBAction)FatherSelected:(id)sender {
    
    _FatherSelected.layer.borderColor = [UIColor blueColor].CGColor;
    _FatherSelected.tintColor = [UIColor blueColor];
    [_FatherSelected setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _MotherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _MotherSelected.tintColor = [UIColor grayColor];
    [_MotherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    _AnotherRelationship.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _AnotherRelationship.tintColor = [UIColor grayColor];
    [_AnotherRelationship setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
- (IBAction)MotherSelected:(id)sender {
    
    _MotherSelected.layer.borderColor = [UIColor blueColor].CGColor;
    _MotherSelected.tintColor = [UIColor blueColor];
    [_MotherSelected setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _FatherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _FatherSelected.tintColor = [UIColor grayColor];
    [_FatherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    _AnotherRelationship.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _AnotherRelationship.tintColor = [UIColor grayColor];
    [_AnotherRelationship setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
- (IBAction)AnotherRelationship:(id)sender {
    
}


-(void)chooseDate:(UIDatePicker*)datePickerView {
    NSDate *date = datePickerView.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY/MM/dd"];
    BirthdayTextField.text = [df stringFromDate:date];
}

-(void)BirthdayDateConformButton {
    [datePicker removeFromSuperview];
    [BirthdayTextField resignFirstResponder];
    NSLog(@"確定");
}

-(void)SettingChildNameAndBirthday {
    
    MyName.layer.cornerRadius=15.0;
    //MyName.layer.borderWidth = 2.0;
    //MyName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //MyName.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    MyName.backgroundColor = [UIColor lightGrayColor];
    MyName.alpha = 0.5;
    //MyName.layer.masksToBounds = YES;
    
    BirthdayTextField.layer.cornerRadius=15.0;
    //BirthdayTextField.layer.borderWidth = 2.0;
    //BirthdayTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    BirthdayTextField.backgroundColor = [UIColor lightGrayColor];
    BirthdayTextField.alpha = 0.5;
    //BirthdayTextField.layer.masksToBounds = YES;
    
    // Prepare DatePicker to BirthdayTextField.
    BirthdayTextField.placeholder = @"YYYY/MM/DD";
    datePicker = [UIDatePicker new];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    BirthdayTextField.inputView = datePicker;
    
    // Prepare Toolbar to add BirthdayTextField.
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,fullScreenBounds.size.width,40)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    
    // Prepare Button to add Toolbar.
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * Right = [[UIBarButtonItem alloc] initWithTitle:@"確定" style:UIBarButtonItemStyleDone
                                                              target:self action:@selector(BirthdayDateConformButton)];
    NSArray *buttons = [NSArray arrayWithObjects: flexible,Right, nil];
    [toolBar setItems:buttons animated:YES];
    BirthdayTextField.inputAccessoryView = toolBar;
}

-(void)SettingChildGender {
    
    BoySelected.layer.cornerRadius=15.0;
    BoySelected.layer.borderWidth = 1.0;
    BoySelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_BoySelected.backgroundColor = [UIColor lightGrayColor];
    [BoySelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIImage *MaleImage = [[UIImage imageNamed:@"Male30x30@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [BoySelected setImage:MaleImage forState:UIControlStateNormal];
    BoySelected.tintColor = [UIColor grayColor];
    
    
    GirlSelected.layer.cornerRadius=15.0;
    GirlSelected.layer.borderWidth = 1.0;
    GirlSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_GirlSelected.backgroundColor = [UIColor lightGrayColor];
    [GirlSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIImage *FemaleImage = [[UIImage imageNamed:@"Female34x34@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [GirlSelected setImage:FemaleImage forState:UIControlStateNormal];
    GirlSelected.tintColor = [UIColor grayColor];
    
    
    AnotherSelected.layer.cornerRadius=15.0;
    AnotherSelected.layer.borderWidth = 1.0;
    AnotherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_GirlSelected.backgroundColor = [UIColor lightGrayColor];
    [AnotherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIImage *AnotherImage = [[UIImage imageNamed:@"Another32x38@2x"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [AnotherSelected setImage:AnotherImage forState:UIControlStateNormal];
    AnotherSelected.tintColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)NextStepToSettingBigStickers {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    //[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    BigStickerSettingViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"BigStickerSettingViewController"];
    //[self presentViewController:nextPage animated:YES completion:nil];
    [self presentViewController:nextPage animated:NO completion:nil];
}

-(void)CancelAddChildSettingViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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