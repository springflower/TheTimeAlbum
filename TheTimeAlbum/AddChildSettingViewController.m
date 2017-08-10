//
//  AddChildSettingViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "AddChildSettingViewController.h"
#import "BigStickerSettingViewController.h"
#import "SliderMenuViewLeft.h"

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
    NSMutableArray *putChildTextFieldnameArray;
    NSMutableArray *putChildBirthdayFieldArray;

    NSInteger ChildSex;
    NSInteger WithRelationship;
    NSUserDefaults *defaults;
    CGRect fullScreenBounds;
    UIDatePicker *datePicker;
    UITableView * testtable;
    BOOL Dismiss;
}
@synthesize ChildNameTextField = ChildNameTextField;
@synthesize BirthdayTextField = BirthdayTextField;
@synthesize BoySelected = BoySelected;
@synthesize GirlSelected = GirlSelected;
@synthesize AnotherSelected = AnotherSelected;

-(void)viewWillAppear:(BOOL)animated {
    
    NSArray *readChildTextFieldnameArray = [defaults objectForKey:@"ChildName"];
    if(readChildTextFieldnameArray) {
        putChildTextFieldnameArray  = [readChildTextFieldnameArray mutableCopy];
    } else {
        putChildTextFieldnameArray = [NSMutableArray new];
    }
    
    NSArray *readChildBirthdayFieldArray = [defaults objectForKey:@"ChildBirthday"];
    if(readChildBirthdayFieldArray) {
        putChildBirthdayFieldArray  = [readChildBirthdayFieldArray mutableCopy];
    } else {
        putChildBirthdayFieldArray = [NSMutableArray new];
    }
    
    if (Dismiss == true) {
        Dismiss = false;
        [self dismissViewControllerAnimated:NO completion:nil];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissViewController) name:@"dimssAddChildSettingViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveChildNameAndBirthday) name:@"saveChildNameAndBirthday" object:nil];

}

-(void)dissMissViewController {
    Dismiss = true;
}

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

-(void)CancelAddChildSettingViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)NextStepToSettingBigStickers {
    if(!(ChildNameTextField.text.length == 0) &&
       !(BirthdayTextField.text.length == 0) &&
       !(ChildSex == 0) &&
       !(WithRelationship == 0)){

        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenLeftMenu" object:nil];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.2;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        //[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        
        BigStickerSettingViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"BigStickerSettingViewController"];
        //[self presentViewController:nextPage animated:YES completion:nil];
        [self presentViewController:nextPage animated:NO completion:nil];

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

-(void) showAlert:(NSString*) messsage {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:messsage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}
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

-(void) saveChildNameAndBirthday {
    
    [putChildTextFieldnameArray addObject:ChildNameTextField.text];
    [putChildBirthdayFieldArray addObject:BirthdayTextField.text];
    
    [defaults setObject:putChildTextFieldnameArray forKey:@"ChildName"];
    [defaults setObject:putChildBirthdayFieldArray forKey:@"ChildBirthday"];
    
    if(ChildSex == 1) {
        [defaults setObject:BoySelected.titleLabel.text forKey:@"ChildSex"];
    } else if(ChildSex == 2) {
        [defaults setObject:GirlSelected.titleLabel.text forKey:@"ChildSex"];
    } else {
        [defaults setObject:AnotherSelected.titleLabel.text forKey:@"ChildSex"];
    }
    
    if(WithRelationship == 1) {
        [defaults setObject:_FatherSelected.titleLabel.text forKey:@"WithRelationShip"];
    } else if(WithRelationship == 2) {
        [defaults setObject:_MotherSelected.titleLabel.text forKey:@"WithRelationShip"];
    } else {
        [defaults setObject:_AnotherRelationship.titleLabel.text forKey:@"WithRelationShip"];
    }
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
