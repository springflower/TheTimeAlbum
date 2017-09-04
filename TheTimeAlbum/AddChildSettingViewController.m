//
//  AddChildSettingViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import <AFNetworking.h>
#import "SliderMenuViewLeft.h"
#import "AddChildSettingViewController.h"
#import "BigStickerSettingViewController.h"
#import "UseDownloadDataClass.h"
#import <ChameleonFramework/Chameleon.h>


@interface AddChildSettingViewController ()<UITableViewDelegate,
                                            UITableViewDataSource,
                                            UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *BoySelected;
@property (weak, nonatomic) IBOutlet UIButton *GirlSelected;
@property (weak, nonatomic) IBOutlet UIButton *AnotherSelected;
@property (weak, nonatomic) IBOutlet UIButton *FatherSelected;
@property (weak, nonatomic) IBOutlet UIButton *MotherSelected;
@property (weak, nonatomic) IBOutlet UIButton *AnotherRelationship;
@property (weak, nonatomic) IBOutlet UITextField *ChildNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *BirthdayTextField;
@end

@implementation AddChildSettingViewController
{
    //準備讀取孩子名字陣列
    NSMutableArray *putChildTextFieldnameArray;
    //準備讀取孩子生日陣列
    NSMutableArray *putChildBirthdayFieldArray;
    //準備讀取儲存的個人信件數量
    NSMutableArray *putDateArray;
    //準備讀取儲存的個人信件內容數量
    NSMutableArray *putTextViewArray;
    //準備讀取孩子性別陣列
    NSMutableArray *putChildSexArray;
    //準備讀取與孩子的關係陣列
    NSMutableArray *putWithChildRelationShipArray;
    //準備讀取孩子的背景陣列
    NSMutableArray *putMyChildBackImageArray;
    //準備讀取孩子的性別選項
    NSInteger ChildSex;
    //準備讀取與孩子的關係選項
    NSInteger WithRelationship;
    //準備讀取儲存的資料
    NSUserDefaults *defaults;
    //準備 Frame
    CGRect fullScreenBounds;
    //準備 datePicker
    UIDatePicker *datePicker;
    
    UITableView * testtable;
    //準備結束 AddChildSettingViewController
    BOOL Dismiss;
    //準備取消按鈕
    UIBarButtonItem *CancelBtn;
    
    NSInteger ChildID;

}
@synthesize ChildNameTextField = ChildNameTextField;
@synthesize BirthdayTextField = BirthdayTextField;
@synthesize BoySelected = BoySelected;
@synthesize GirlSelected = GirlSelected;
@synthesize AnotherSelected = AnotherSelected;

-(void)viewWillAppear:(BOOL)animated {
    
    //讀取是否已有建立第一個孩子 Name.
    NSUserDefaults *readChildIdDefaults;
    readChildIdDefaults = [NSUserDefaults standardUserDefaults];
    //如果讀出的陣列數量為零的話，就執行 AddChildSettingViewController 來創造第一個孩子。
    NSArray *readChildNameArray = [readChildIdDefaults objectForKey:@"ChildName"];
    if(readChildNameArray.count == 0) {
        CancelBtn.enabled = false;
    } else {
        CancelBtn.enabled = true;
    }
    //讀取孩子的名稱陣列
    NSArray *readChildTextFieldnameArray = [defaults objectForKey:@"ChildName"];
    if(readChildTextFieldnameArray.count != 0) {
        putChildTextFieldnameArray  = [readChildTextFieldnameArray mutableCopy];
    } else {
        putChildTextFieldnameArray = [NSMutableArray new];
    }
    //讀取孩子的生日陣列
    NSArray *readChildBirthdayFieldArray = [defaults objectForKey:@"ChildBirthday"];
    if(readChildBirthdayFieldArray.count != 0) {
        putChildBirthdayFieldArray  = [readChildBirthdayFieldArray mutableCopy];
    } else {
        putChildBirthdayFieldArray = [NSMutableArray new];
    }
    //讀取孩子的個人信件陣列
    NSArray *readDateArray = [defaults objectForKey:@"Mailibformation"];
    if(readDateArray.count != 0) {
        putDateArray  = [readDateArray mutableCopy];
    } else {
        putDateArray = [NSMutableArray new];
    }
    //讀取孩子的個人信件內容陣列
    NSArray *readTextViewArray = [defaults objectForKey:@"textViewcontent"];
    if(readTextViewArray.count != 0) {
        putTextViewArray  = [readTextViewArray mutableCopy];
    } else {
        putTextViewArray = [NSMutableArray new];
    }
    //讀取孩子的性別陣列
    NSArray *readChildSexArray = [defaults objectForKey:@"readChildSexArray"];
    if(readChildSexArray.count != 0) {
        putChildSexArray = [readChildSexArray mutableCopy];
    } else {
        putChildSexArray = [NSMutableArray new];
    }
    //讀取與孩子的關係陣列
    NSArray *readWithChildRelationShipArray = [defaults objectForKey:@"readWithChildRelationShipArray"];
    if(readWithChildRelationShipArray.count != 0) {
        putWithChildRelationShipArray = [readWithChildRelationShipArray mutableCopy];
    } else {
        putWithChildRelationShipArray = [NSMutableArray new];
    }
    //準備讀取儲存的孩子背景圖片陣列
    NSArray *readMyChildBackImageArray = [defaults objectForKey:@"readMyChildBackImageArray"];
    if(readMyChildBackImageArray) {
        putMyChildBackImageArray  = [readMyChildBackImageArray mutableCopy];
    } else {
        putMyChildBackImageArray = [NSMutableArray new];
    }
    
    //判斷當 BigStickerSettingViewControler 按下完成後，就結束 AddChildSettingViewControler.
    if (Dismiss == true) {
        Dismiss = false;
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    
    self.navigationItem.title = @"設定";
    
    [self SettingChildNameAndBirthday];
    
    [self SettingChildGender];
    
    // Prepare the Button add to NavigationBar.
    UIBarButtonItem *NextStep = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:
                                 UIBarButtonItemStyleDone target:self action:@selector(NextStepToSettingBigStickers)];
    self.navigationItem.rightBarButtonItem = NextStep;
    CancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:
                                UIBarButtonItemStyleDone target:self action:@selector(CancelAddChildSettingViewController)];
    self.navigationItem.leftBarButtonItem = CancelBtn;
    
    
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
    
    //通知接收執行 dissMissViewController  View
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissViewController)
                                                 name:@"dimssAddChildSettingViewController" object:nil];
    //通知執行 saveChildNameAndBirthday 儲存資料
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveChildNameAndBirthday) name:@"saveChildInformation" object:nil];
    
    //通知執行上傳孩子資訊資料
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUpdateChildInformation) name:@"saveUpdateChildInformation" object:nil];
    

}



-(void)dissMissViewController {
      Dismiss = true;
}

#pragma mark  - Setting ChildSexSelected 設定孩子性別選項

- (IBAction)BoySelected:(id)sender {
    ChildSex = 1;
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
    ChildSex = 2;
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
    ChildSex = 3;
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

#pragma mark - Setting With ChildRelationship 設定與孩子的關係選項

- (IBAction)FatherSelected:(id)sender {
    WithRelationship = 1;
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
    WithRelationship = 2;
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
    WithRelationship = 3;
    UIActionSheet *myActionSheet =  [[UIActionSheet alloc]
                                    initWithTitle:@"您與孩子的關係"
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"爺爺", @"奶奶",@"外公",@"外婆",@"自訂", nil];
    
    [myActionSheet showInView:self.view];
    
    _AnotherRelationship.layer.borderColor = [UIColor blueColor].CGColor;
    _AnotherRelationship.tintColor = [UIColor blueColor];
    [_AnotherRelationship setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _FatherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _FatherSelected.tintColor = [UIColor grayColor];
    [_FatherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    _MotherSelected.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _MotherSelected.tintColor = [UIColor grayColor];
    [_MotherSelected setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
}

#pragma mark - Setting With ChildRelationship AnotherSelected 設定 actionSheet 與孩子關係其他選項

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:
                   (NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [_AnotherRelationship setTitle:@"爺爺" forState:UIControlStateNormal];
            break;
        case 1:
            [_AnotherRelationship setTitle:@"奶奶" forState:UIControlStateNormal];
            break;
        case 2:
            [_AnotherRelationship setTitle:@"外公" forState:UIControlStateNormal];
            break;
        case 3:
            [_AnotherRelationship setTitle:@"外婆" forState:UIControlStateNormal];
            break;
        case 4:
            [self showAnotherRelationship];
            break;
        default:
            break;
    }
}

#pragma mark - Setting ChildBirthday add DatePicker. 設定 DatePicker 加入到設定孩子生日 TextField 裡面

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
    
    ChildNameTextField.layer.cornerRadius=15.0;
    //MyName.layer.borderWidth = 2.0;
    //MyName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //MyName.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    ChildNameTextField.backgroundColor = [UIColor lightGrayColor];
    ChildNameTextField.alpha = 0.5;
    //MyName.layer.masksToBounds = YES;
    
    BirthdayTextField.layer.cornerRadius=15.0;
    //BirthdayTextField.layer.borderWidth = 2.0;
    //BirthdayTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    BirthdayTextField.backgroundColor = [UIColor lightGrayColor];
    BirthdayTextField.alpha = 0.5;
    //BirthdayTextField.layer.masksToBounds = YES;
    
    // Prepare DatePicker to BirthdayTextField.
    //BirthdayTextField.placeholder = @"YYYY/MM/DD";
    datePicker = [UIDatePicker new];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    BirthdayTextField.inputView = datePicker;
    
    // Prepare Toolbar to add BirthdayTextField.
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,fullScreenBounds.size.width,40)];
    toolBar.backgroundColor = [UIColor flatSkyBlueColor];
    // Prepare Button to add Toolbar.
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * Right = [[UIBarButtonItem alloc] initWithTitle:@"確定" style:UIBarButtonItemStyleDone
                                                              target:self action:@selector(BirthdayDateConformButton)];
    NSArray *buttons = [NSArray arrayWithObjects: flexible,Right, nil];
    [toolBar setItems:buttons animated:YES];
    BirthdayTextField.inputAccessoryView = toolBar;
}

#pragma  mark - Setting ChildSex Selected Button Frame. 準備設定孩子性別按鍵設定

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

#pragma mark - Setting to DimissViewControler 設定退出 AddChildSettingViewController

-(void)CancelAddChildSettingViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setting to next page 設定執行到下一頁

-(void)NextStepToSettingBigStickers {
    if(!(ChildNameTextField.text.length == 0) &&
       !(BirthdayTextField.text.length == 0) &&
       !(ChildSex == 0) &&
       !(WithRelationship == 0)){
        
        //設定通知來隱藏左側選單
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenLeftMenu" object:nil];
        //準備上傳全部資料的陣列
        NSMutableArray *updateAlldataArray = [NSMutableArray new];
        [updateAlldataArray addObject:ChildNameTextField.text];
        [updateAlldataArray addObject:BirthdayTextField.text];
        
        
        
        BigStickerSettingViewController *editController = [self.storyboard instantiateViewControllerWithIdentifier:@"BigStickerSettingViewController"];
        [self.navigationController pushViewController:editController animated:YES];

    } else {
        if([ChildNameTextField.text isEqualToString:@""]) {
            [self showAlert:@"稱號必須填"];
        } else if([BirthdayTextField.text isEqualToString:@""]){
            [self showAlert:@"出生年月日必須填"];
        } else if(ChildSex == 0) {
            [self showAlert:@"性別必須填"];
        } else {
            [self showAlert:@"關係必須填"];
        }
    }
}

#pragma mark - Setting showAlert add View 設定 showAlert 當設定有空白時提醒使用者

-(void) showAlert:(NSString*) messsage {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:messsage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Setting showAnotherRelationship add AntherRelationShip 設定 UIAlertController 加入其他關係選項

-(void) showAnotherRelationship {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"稱呼";
    }];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_AnotherRelationship setTitle:alert.textFields[0].text forState:UIControlStateNormal];
    }];
    
    UIAlertAction * Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:Cancel];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)saveUpdateChildInformation {
    
    NSString *putChildSex;
    NSString *WithChildRelationShip;
    //儲存小孩性別陣列
    if(ChildSex == 1) {
        putChildSex = BoySelected.titleLabel.text;
    } else if(ChildSex == 2) {
        putChildSex = GirlSelected.titleLabel.text;
    } else {
        putChildSex = AnotherSelected.titleLabel.text;
    }
    //儲存你與孩子的關係
    if(WithRelationship == 1) {
        WithChildRelationShip = _FatherSelected.titleLabel.text;
    } else if(WithRelationship == 2) {
        WithChildRelationShip = _MotherSelected.titleLabel.text;
    } else {
        WithChildRelationShip = _AnotherRelationship.titleLabel.text;
    }

    [[UseDownloadDataClass object] PutChildInformation:ChildNameTextField.text
                                   ChildBirthday:BirthdayTextField.text
                                   ChildSex:putChildSex
                                   WithChildRelationShip:WithChildRelationShip];
}

#pragma mark - Prepare Save Data 準備儲存所選擇的資料

-(void)saveChildNameAndBirthday {

    //增加小孩名字到陣列中
    [putChildTextFieldnameArray addObject:ChildNameTextField.text];
    //增加小孩生日到陣列中
    [putChildBirthdayFieldArray addObject:BirthdayTextField.text];
    //增加信件陣列數量給存放孩子個人信件的陣列
    NSArray *emptyArray = [NSArray new];
    [putDateArray addObject:emptyArray];
    //增加信件內容數量給存放孩子個人信件內容陣列
    [putTextViewArray addObject:emptyArray];
    
    //儲存當下的小孩ID
    //[defaults setInteger:ChildID forKey:@"ChildID"];
    //儲存小孩名字陣列
    [defaults setObject:putChildTextFieldnameArray forKey:@"ChildName"];
    //儲存小孩生日陣列
    [defaults setObject:putChildBirthdayFieldArray forKey:@"ChildBirthday"];
    //儲存信件陣列給存放孩子個人信件的陣列
    [defaults setObject:putDateArray forKey:@"Mailibformation"];
    //儲存信件內容陣列給存放孩子個人信件內容的陣列
    [defaults setObject:putTextViewArray forKey:@"textViewcontent"];
    //儲存小孩性別陣列
    if(ChildSex == 1) {
        [putChildSexArray addObject:BoySelected.titleLabel.text];
        [defaults setObject:putChildSexArray forKey:@"readChildSexArray"];
    } else if(ChildSex == 2) {
        [putChildSexArray addObject:GirlSelected.titleLabel.text];
        [defaults setObject:putChildSexArray forKey:@"readChildSexArray"];
    } else {
        [putChildSexArray addObject:AnotherSelected.titleLabel.text];
        [defaults setObject:putChildSexArray forKey:@"readChildSexArray"];
    }
    //儲存你與孩子的關係
    if(WithRelationship == 1) {
        [putWithChildRelationShipArray addObject:_FatherSelected.titleLabel.text];
        [defaults setObject:putWithChildRelationShipArray forKey:@"readWithChildRelationShipArray"];
    } else if(WithRelationship == 2) {
        [putWithChildRelationShipArray addObject:_MotherSelected.titleLabel.text];
        [defaults setObject:putWithChildRelationShipArray forKey:@"readWithChildRelationShipArray"];
    } else {
        [putWithChildRelationShipArray addObject:_AnotherRelationship.titleLabel.text];
        [defaults setObject:putWithChildRelationShipArray forKey:@"readWithChildRelationShipArray"];
    }
    //將孩子的背景圖片隨機產生，儲存在孩子的背景陣列中
    int x = arc4random() % 5;
    NSArray *randomBackgroundImageArray = @[@"background1@2x.jpg",
                                            @"background2@2x.jpg",
                                            @"background3@2x.jpg",
                                            @"background4@2x.jpg",
                                            @"background5@2x.jpg"];
    NSString *MyChildBackImage = [[NSString alloc]initWithString:randomBackgroundImageArray[x]];
    [putMyChildBackImageArray addObject:MyChildBackImage];
    [defaults setObject:putMyChildBackImageArray forKey:@"readMyChildBackImageArray"];
    NSLog(@"  數量為： %lu ",
          (unsigned long)putMyChildBackImageArray.count);
    //設定如果孩子的名字只有一個，將孩子 ID 設為 0
    if(putChildTextFieldnameArray.count == 1) {
        [defaults setInteger:0 forKey:@"ChildID"];
    }
    
    [defaults synchronize];
    

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
