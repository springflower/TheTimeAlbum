//
//  SetInfoTableViewControler.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/21.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import <Photos/Photos.h>
#import "UpdateDataView.h"
#import "UseDownloadDataClass.h"
#import "AboutMeViewcontrollerCell.h"
#import "SetInfoTableViewControler.h"
#import <ChameleonFramework/Chameleon.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AddChildSettingViewController.h"
#import <ChameleonFramework/Chameleon.h>

@interface SetInfoTableViewControler ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIApplicationDelegate>

@end

@implementation SetInfoTableViewControler
{
    //準備讀取目前選擇的小孩ID.
    NSInteger ChildID;
    //準備讀取儲存的檔案
    NSUserDefaults *defaults;
    //準備讀取孩子名字陣列
    NSMutableArray *putChildTextFieldnameArray;
    //準備讀取孩子生日陣列
    NSMutableArray *putChildBirthdayFieldArray;
    //準備放置孩子性別陣列
    NSMutableArray *putChildSexArray;
    //準備放置與孩子關係陣列
    NSMutableArray *putWithChildRelationShipArray;
    //準備放置孩子大頭貼陣列
    NSMutableArray *putChildBigStickerArray;
    //準備讀取孩子背景圖
    NSMutableArray *putMyChildBackImageArray;
    //準備放置孩子大頭貼資料
    UIImageView *ChidlBigStickerImageView;
    //準備放置陣列 packegUserArray 與 SettingChildInfo 陣列
    NSMutableArray *putinformationArray;
    //準備放置孩子資料陣列來顯示在 TableView 上
    NSMutableArray *packegChildInfoArray;
    //準備放置孩子資料內容陣列
    NSMutableArray *ChildDataArray;
    //準備放置所選取的孩子大頭貼照片
    UIImage *ChildBigStickerImage;
    //準備放置所選取的背景圖片
    UIImage *ChildBackgroundImage;
    //準備暫存更改的孩子名字
    NSString *ChildName;
    //準備暫存更改的孩子生日
    NSString *ChildBirthday;
    //準備 UIDatePicker
    UIDatePicker *datePicker;
    //準備 Frame
    CGRect fullScreenBounds;
    //準備 UIView 給 UIDatePicker
    UIView *datePickerView;
    //準備使用相簿與相機功能
    UIImagePickerController *picker;
    //準備上傳資料使用
    UpdateDataView *updateChildBigstickerArray;
    //準備判斷選擇的是更改大頭貼還是背景圖片
    int chooseImageChangeSelect;
    
    UIApplication *application;
    
    UIBackgroundTaskIdentifier bgTask;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"孩子設定";
    
    //設定螢幕的寬高給 fullScreenBounds
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    //進行 TableView 更新
    [self reloadTableView];
    }

-(void)reloadTableView {
    NSLog(@"已更新資料");
    //準備讀取儲存的資料
    defaults = [NSUserDefaults standardUserDefaults];
    //讀取目前所選擇的小孩ID
    ChildID = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChildID"];
    
    //準備讀取所創建的孩子名字，根據所選取的孩子名稱來決定信件上孩子的名字。
    NSArray *readChildTextFieldnameArray = [defaults objectForKey:@"ChildName"];
    if(readChildTextFieldnameArray.count != 0) {
        putChildTextFieldnameArray = [readChildTextFieldnameArray mutableCopy];
        ChildName = readChildTextFieldnameArray[ChildID];
    } else {
        putChildTextFieldnameArray = [NSMutableArray new];
    }
    //準備讀取孩子生日陣列
    NSArray *readChildBirthdayFieldArray = [defaults objectForKey:@"ChildBirthday"];
    if(readChildBirthdayFieldArray.count != 0) {
        putChildBirthdayFieldArray = [readChildBirthdayFieldArray mutableCopy];
        ChildBirthday = putChildBirthdayFieldArray[ChildID];
    } else {
        putChildBirthdayFieldArray = [NSMutableArray new];
    }
    //讀取孩子的性別陣列
    NSArray *readChildSexArray = [defaults objectForKey:@"readChildSexArray"];
    if(readChildSexArray.count != 0) {
        putChildSexArray = [readChildSexArray mutableCopy];
    } else {
        putChildSexArray = [NSMutableArray new];
    }
    //讀取與孩子關係陣列
    NSArray *readWithChildRelationShipArray = [defaults objectForKey:@"readWithChildRelationShipArray"];
    if(readWithChildRelationShipArray.count != 0) {
        putWithChildRelationShipArray = [readWithChildRelationShipArray mutableCopy];
    } else {
        putWithChildRelationShipArray = [NSMutableArray new];
    }

    //準備讀取孩子的大頭貼
    if([[UseDownloadDataClass object] ReadChildBigStickerArray].count != 0) {
        NSArray  *readChildBigStickerArray = [[UseDownloadDataClass object] ReadChildBigStickerArray];
        if(readChildBigStickerArray) {
            putChildBigStickerArray = [readChildBigStickerArray mutableCopy];
            NSData* ChildBigStickerImageData = [readChildBigStickerArray objectAtIndex:ChildID];
            ChidlBigStickerImageView.image = [UIImage imageWithData:ChildBigStickerImageData];
            ChildBigStickerImage = [[UIImage alloc] initWithData:ChildBigStickerImageData];
            NSLog(@"原生照片為： %@",ChildBigStickerImage);
        }
    }
    //讀取孩子背景圖片陣列
    NSArray *readMyChildBackImageArray = [defaults objectForKey:@"readMyChildBackImageArray"];
    if(readMyChildBackImageArray) {
        putMyChildBackImageArray = [readMyChildBackImageArray mutableCopy];
    }
    else {
        putMyChildBackImageArray = [NSMutableArray new];
    }
    //設定要選擇的設定說明
    NSArray *SettingChildInfo = @[@"更換孩子姓名",@"更換孩子生日"];
    NSArray *SettingChildImage = @[@"更換孩子大頭貼",@"更換背景圖片"];
    NSArray *DeleteCurrentAccount = @[@"刪除目前帳號"];
    
    //放置所選取的孩子資料到 ChildDataArray
    if(putChildTextFieldnameArray.count != 0 && putChildBirthdayFieldArray.count != 0) {
        
        ChildDataArray = [[NSMutableArray alloc]
                          initWithObjects:ChildBigStickerImage,
                          putChildTextFieldnameArray[ChildID],
                          putChildBirthdayFieldArray[ChildID], nil];
        //放置 ChildDataArray 陣列到 packegChildInfoArray
        packegChildInfoArray = [[NSMutableArray alloc] initWithObjects:ChildDataArray, nil];
        //放置兩個陣列到 putinformationArray
        putinformationArray = [[NSMutableArray alloc]
                               initWithObjects:
                               packegChildInfoArray,SettingChildInfo,SettingChildImage,DeleteCurrentAccount, nil];
    }

    
    //開始上傳資料並設定更新動畫執行
    
//    updateChildBigstickerArray = [[UpdateDataView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [[UIApplication sharedApplication].delegate.window addSubview:updateChildBigstickerArray];
//    updateChildBigstickerArray.hidden = true;
    
    //準備接收通知更新 SetInfoTableViewControler
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"SetInfoTableViewControler" object:nil];
    //準備接收通知關閉 PopSetInfoTableViewControler
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backLatPage:) name:@"PopSetInfoTableViewControler" object:nil];
    //準備接收通知上傳成功可以刪除本機資料了 SetInfoTableViewControler
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(deleteUpdateSuccessStartDleteUserDefaultData) name:@"DeleteDataFromSetInfoTableViewControler" object:nil];
    //準備接收通知上傳成功可以修改本機資料了 SetInfoTableViewControler
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changeUpdateSuccessStartchangeUserDefaultData) name:@"ChangeDataFromSetInfoTableViewControler" object:nil];
    [self.tableView reloadData];
}



#pragma mark - Prepare to Save Currrent Account 準備修改目前選取的小孩資料並上傳

- (IBAction)Finished:(id)sender {
    
//    [[UseDownloadDataClass object] PutChangeChildInformation:ChildName ChangeChildBirthday:ChildBirthday];
    
//    application = [UIApplication sharedApplication];
    
//    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        //將更新動畫顯示
//        updateChildBigstickerArray.hidden = false;
//        //將更改後的孩子大頭貼放到目前選取的孩子大頭貼陣列
//        NSData *ChildBigStickerImageData = [NSData dataWithData:UIImagePNGRepresentation(ChildBigStickerImage)];
//        putChildBigStickerArray[ChildID] = ChildBigStickerImageData;
//        
//        //上傳更改後的孩子大頭貼陣列
//        [updateChildBigstickerArray UpdataChildBigstickerIfUseChangeunction:putChildBigStickerArray];

//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
    
}

#pragma mark - Prepare to if StartBeginchangeUpdateData Success delete UserDefaultData 如果更改資料上傳成功就更新資料

-(void)changeUpdateSuccessStartchangeUserDefaultData {
    
    //將更改後的孩子名字放到目前選取的孩子名字陣列位置
    putChildTextFieldnameArray[ChildID] = ChildName;
    //將更改後的孩子生日放到目前選取的孩子生日陣列位置
    putChildBirthdayFieldArray[ChildID] = ChildBirthday;
    //儲存更改後的孩子名字陣列
    [defaults setObject:putChildTextFieldnameArray forKey:@"ChildName"];
    //儲存更改後的孩子生日陣列
    [defaults setObject:putChildBirthdayFieldArray forKey:@"ChildBirthday"];
    //儲存更改後的孩子背景圖片陣列，判斷 ChildBackgroundImage 是否有值
    if(ChildBackgroundImage) {
        NSData* MyChildBackgroundData = [NSData dataWithData:UIImagePNGRepresentation(ChildBackgroundImage)];
        putMyChildBackImageArray[ChildID] = MyChildBackgroundData;
        [defaults setObject:putMyChildBackImageArray forKey:@"readMyChildBackImageArray"];
    }
    //同步 NSUserDefault 資料
    [defaults synchronize];
}

#pragma mark - Prepare to delete Currrent Account 準備刪除目前選取的小孩資料並上傳

-(void)StartBeginUpdateDleteData {
    
    //刪除目前所選取的小孩大頭貼
    [putChildBigStickerArray removeObjectAtIndex:ChildID];
    //將更新動畫顯示
    updateChildBigstickerArray.hidden = false;
    //上傳更改後的孩子大頭貼陣列
    [updateChildBigstickerArray UpdataChildBigstickerIfUseDeleteFunction:putChildBigStickerArray];
}



#pragma mark - Prepare to if StartBeginUpdateDleteData Success delete UserDefaultData 如果刪除上傳成功就執行刪除資料

-(void)deleteUpdateSuccessStartDleteUserDefaultData {
    //刪除目前所選取的小孩名字
    [putChildTextFieldnameArray removeObjectAtIndex:ChildID];
    [defaults setObject:putChildTextFieldnameArray forKey:@"ChildName"];
    //刪除目前所選取的小孩生日
    [putChildBirthdayFieldArray removeObjectAtIndex:ChildID];
    [defaults setObject:putChildBirthdayFieldArray forKey:@"ChildBirthday"];
    //刪除目前所選取的小孩性別
    [putChildSexArray removeObjectAtIndex:ChildID];
    [defaults setObject:putChildSexArray forKey:@"readChildSexArray"];
    //刪除目前所選取的與小孩的關係
    [putWithChildRelationShipArray removeObjectAtIndex:ChildID];
    [defaults setObject:putWithChildRelationShipArray forKey:@"readWithChildRelationShipArray"];
    //刪除目前所選取的小孩背景圖片
    [putMyChildBackImageArray removeObjectAtIndex:ChildID];
    [defaults setObject:putMyChildBackImageArray forKey:@"readMyChildBackImageArray"];
    //設定當刪除成功時，將選取的孩子 ID 更換為上一個孩子，如果為第一個孩子，就不變動
    if(ChildID > 0) {
        NSInteger NewChildID = ChildID - 1;
        [defaults setInteger:NewChildID forKey:@"ChildID"];
    } else {
        NSInteger NewChildID = ChildID;
        [defaults setInteger:NewChildID forKey:@"ChildID"];
    }
    
    //同步 NSUserDefault 資料
    [defaults synchronize];
}

#pragma mark - Prepare to back last page 準備回到上一頁設定

- (IBAction)backLatPage:(id)sender {
    
    datePickerView.hidden = true;
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Table view data source Setting 準備設定 UITalbeViewCell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return putinformationArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[putinformationArray objectAtIndex:section] count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AboutMeViewcontrollerCell *myCell=[[AboutMeViewcontrollerCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Menu"];
    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section == 0) {
        myCell.imageView.layer.cornerRadius = 32;
        myCell.imageView.clipsToBounds = YES;
        myCell.imageView.layer.borderWidth = 1.0;
        myCell.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        myCell.imageView.layer.masksToBounds = YES;
        //防止還沒下載完資料就讀取大頭貼
        if(ChildDataArray.count > 2) {
            myCell.imageView.image = ChildBigStickerImage;
            myCell.textLabel.text =
            [NSString stringWithFormat:@"%@(%@)",[ChildDataArray objectAtIndex:1],putChildSexArray[ChildID]];
            myCell.detailTextLabel.text =
            [NSString stringWithFormat:@"%@%@",@"生日：",[ChildDataArray objectAtIndex:2]];
        }
        return myCell;
    } else if(indexPath.section == 1){
        if(indexPath.row == 0) {
            myCell.textLabel.text = [[putinformationArray objectAtIndex:1] objectAtIndex:0];
            myCell.detailTextLabel.text = ChildName;
        } else {
            myCell.textLabel.text = [[putinformationArray objectAtIndex:1] objectAtIndex:1];
            myCell.detailTextLabel.text = ChildBirthday;
        }
        return myCell;
    } else if(indexPath.section == 2){
            myCell.textLabel.text = [[putinformationArray objectAtIndex:2] objectAtIndex:indexPath.row];
        return myCell;
    } else if(indexPath.section == 3){
        myCell.textLabel.textAlignment = NSTextAlignmentCenter;
        myCell.textLabel.text = [[putinformationArray objectAtIndex:3] objectAtIndex:0];
        myCell.textLabel.textColor = [UIColor redColor];
        //無效
        myCell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return myCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //為table Cell 加上選取後的動畫。
    
    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            [self showChildNameAlertAction:ChildName];
        } else if(indexPath.row == 1) {
            [self SettingChildNameAndBirthday];
        }
    }
    if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            chooseImageChangeSelect = 1;
            [self photoselect];
        } else if(indexPath.row == 1) {
            chooseImageChangeSelect = 2;
            [self photoselect];
        }
    }
    if(indexPath.section == 3) {
        if(indexPath.row == 0) {
            NSString *description = [NSString stringWithFormat:@"確定要刪除『 %@ 』嗎？",ChildName];
            [self showAlert:description];
        }
    }
}


//設定分類開頭標題
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"";
        
    }else {
        return @" ";
    }
    
}
//設定 TableViewCell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 80;
        
    }
    return 50;
    
}

-(void) showAlert:(NSString*) messsage {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:messsage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^
        (UIAlertAction * _Nonnull action) {
            [self StartBeginUpdateDleteData];
    }];
    UIAlertAction * Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:Cancel];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Prepare setting UIAlertController to add ChildName setting 準備 UIAlertController 給孩子名字更改

-(void) showChildNameAlertAction:(NSString*)Text {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = Text;
    }];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ChildName = alert.textFields[0].text;
        [self.tableView reloadData];
    }];
    
    UIAlertAction * Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:Cancel];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Prepare setting UIDatePicker to add ChildBirthday setting 準備 UIDatePicker 給孩子生日更改

-(void)chooseDate:(UIDatePicker*)datePickerView {
    NSDate *date = datePickerView.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY/MM/dd"];
    //BirthdayTextField.text = [df stringFromDate:date];
    ChildBirthday = [df stringFromDate:date];
}

-(void)BirthdayDateConformButton {
    datePickerView.hidden = true;
    NSLog(@"確定");
    [self.tableView reloadData];
}

-(void)SettingChildNameAndBirthday {
    
    datePickerView =
    [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2,
                                             self.view.frame.size.width, self.view.frame.size.height/2)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, datePickerView.frame.size.width, datePickerView.frame.size.height)];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    [datePickerView addSubview:datePicker];
    
    
    // Prepare Toolbar to add BirthdayTextField.
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,fullScreenBounds.size.width,40)];
//    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    toolBar.backgroundColor = [UIColor flatGrayColor];
    
    // Prepare Button to add Toolbar.
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * Right = [[UIBarButtonItem alloc] initWithTitle:@"確定" style:UIBarButtonItemStyleDone
                                                              target:self action:@selector(BirthdayDateConformButton)];
    NSArray *buttons = [NSArray arrayWithObjects: flexible,Right, nil];
    [toolBar setItems:buttons animated:YES];
    [datePickerView addSubview:toolBar];
    
    
//    [self.view addSubview:datePickerView];
    [[UIApplication sharedApplication].delegate.window addSubview:datePickerView];
}

-(void)photoselect {
    
    UIActionSheet *myActionSheet =  [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"相機", @"相簿", nil];
    [myActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:
(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        default:
            break;
    }
}

#pragma mark - Preare to use PhotoLobibrary 準備使用相簿功能或相機功能

-(void) CancelPicture {
    [picker dismissViewControllerAnimated:YES completion: NULL];
}

// Start to Pick Photo and Save.
-(void) launchImagePickerWithSourceType:(UIImagePickerControllerSourceType) sourceType {
    
    //Check if source type avaulable.
    if([UIImagePickerController isSourceTypeAvailable:sourceType] == false) {
        NSLog(@"Invalid Source Type");
        return;
    }
    // Prepare ImagePicker
    picker = [UIImagePickerController new];
    picker.sourceType = sourceType;
    //    picker.mediaTypes = @[@"public.image",@"public.movie"];
    picker.mediaTypes = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeMovie];
    picker.delegate = self;
    
    if(sourceType == UIImagePickerControllerSourceTypeCamera) {
        // Prepare Camera Overlay View.
        picker.showsCameraControls = false;
        
        // Prepare a button.
        UIButton *takeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        takeBtn.frame = CGRectMake(fullScreenBounds.size.width/2-40,500,100,100);
        //[takeBtn setTitle:@"Take" forState:UIControlStateNormal];
        [takeBtn setImage:[UIImage imageNamed:@"Camera150x150@2x.png"] forState:UIControlStateNormal];
        [takeBtn sizeToFit];
        [takeBtn addTarget:picker action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [picker.cameraOverlayView addSubview:takeBtn];
        
        UIButton *cancelBtn = [[UIButton alloc]
                               initWithFrame:CGRectMake(fullScreenBounds.size.width/2-30, 620, 100, 100)];
        [cancelBtn addTarget:self action:@selector(CancelPicture) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor flatBlueColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelBtn sizeToFit];
        [picker.cameraOverlayView addSubview:cancelBtn];
        
    } else {
        picker.allowsEditing = true;
    }
    picker.allowsEditing = true;
    
    [self presentViewController:picker animated:true completion:nil];
    
}

// When Photo Picked Editing Photo
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"Info: %@",info);
    NSString *type = info[UIImagePickerControllerMediaType];
    
    if([type isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *origineImage = info[UIImagePickerControllerOriginalImage];
        UIImage *editImage = info[UIImagePickerControllerEditedImage];
        UIImage *inputImage = editImage != nil ? editImage  : origineImage ;
        
        NSLog(@"originalImage: %fx%f",inputImage.size.width,inputImage.size.height);
        
        UIImage *resizeImage = [self resizeFromImage:inputImage];
        
        NSLog(@"originalImage: %fx%f",origineImage.size.width,origineImage.size.height);
        NSLog(@"resizeImage: %fx%f",resizeImage.size.width,resizeImage.size.height);
                
        
        NSData *jpgData = UIImageJPEGRepresentation(resizeImage, 0.8);
        NSData *pngData = UIImagePNGRepresentation(resizeImage);
        
        NSLog(@"JPG Data: %lu",jpgData.length);
        NSLog(@"PNG Data: %lu",pngData.length);
        
        //判斷是選擇更改孩子大頭貼還是孩子背景圖片
        if(chooseImageChangeSelect == 1) {
            ChildBigStickerImage = editImage;
        } else if(chooseImageChangeSelect == 2) {
            ChildBackgroundImage = editImage;
        }
        [self.tableView reloadData];
        
        
        
    } else if([type isEqualToString:(NSString*)kUTTypeMovie]) {
        
        NSURL *fileURL = info[UIImagePickerControllerMediaURL];
        
        NSLog(@"Movie is placed at: %@",fileURL);
        
        //Using the movie...
        
        //Remove it if it is no longed needed.
        [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
        
    }
    
    // Important!!!
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(UIImage*) resizeFromImage:(UIImage*) input {
    CGFloat maxLength = 1024.0;
    CGSize targetSize;
    UIImage *finalImage;
    UIGraphicsBeginImageContext(targetSize);
    //Check it is necessary to resiz.
    if(input.size.width <= maxLength && input.size.height <=maxLength) {
        finalImage = input;
        targetSize = input.size;
    } else {
        //We Will resize the input image.
        if(input.size.width >= input.size.height) {
            CGFloat ratio = input.size.width / maxLength;
            targetSize = CGSizeMake(maxLength, input.size.height / ratio);
        } else {
            // Height > Width
            CGFloat ratio = input.size.height / maxLength;
            targetSize = CGSizeMake(input.size.width / ratio,maxLength);
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    [input drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    
    finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); //Important!!
    return finalImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
