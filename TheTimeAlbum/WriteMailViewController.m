//
//  WriteMailViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/31.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import <AFNetworking.h>
#import "SelectedRow.h"
#import <Photos/Photos.h>
#import <QuartzCore/QuartzCore.h>
#import "WriteMailViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "MyTextAttachment.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface WriteMailViewController ()<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *BackBtn;
@property (weak, nonatomic) IBOutlet UIButton *KeepMessage;
@property (weak, nonatomic) IBOutlet UIButton *SendMessage;
@property (weak, nonatomic) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet UITableView *MyWriteMailTableView;

@end

@implementation WriteMailViewController
{
    CGRect fullScreenBounds;
    //準備讀取目前選擇的小孩ID.
    NSInteger ChildID;
    //準備使用相簿與相機功能
    UIImagePickerController *picker;
    //準備顯示目前時間與日期
    UILabel *dateLabel;
    //準備讀取儲存的信件日期陣列
    NSMutableArray *putDateArray;
    //準備讀取信件陣列的資料，依照所選的孩子ID
    NSMutableArray *putDateAddArray;
    //準備讀取信件內容陣列的資料，依照所選的孩子ID
    NSMutableArray *putTextViewAddArray;
    //準備讀取儲存的內容數量
    NSMutableArray *putTextViewArray;
    //準備讀取儲存的檔案
    NSUserDefaults *defaults;
    //準備一個字串來顯示日期並儲存
    NSString *dateString;
    //準備讀取所儲存的內容，因為是儲存成Data，所以要先用 NSData
    NSData *content;
    
    int popViewOrdimissViewfunc;
}

-(void)viewWillAppear:(BOOL)animated {
    
    //讀取目前所選擇的小孩ID
    ChildID = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChildID"];
    
    NSLog(@"%d",[[SelectedRow object]didSelectedRowAboutMail]);
    // Read DateArrayContent 讀取存取的日期陣列.
    NSArray *readDateArray = [defaults objectForKey:@"Mailibformation"];
    if(readDateArray.count != 0) {
        putDateArray  = [readDateArray mutableCopy];
        putDateAddArray = [[putDateArray objectAtIndex:ChildID] mutableCopy];
    } else {
        putDateArray = [NSMutableArray new];
        putDateAddArray = [NSMutableArray new];
    }
    
    // Read TextViewArrayContent 讀取存取的信箱內容.
    NSArray *readTextViewArray = [defaults objectForKey:@"textViewcontent"];
    if(readTextViewArray) {
        putTextViewArray = [readTextViewArray mutableCopy];
        putTextViewAddArray = [[putTextViewArray objectAtIndex:ChildID] mutableCopy];
    } else {
        putTextViewArray = [NSMutableArray new];
        putTextViewAddArray = [NSMutableArray new];
    }
    
    [self MyWriteMailTableViewPrepare];
    
    // Read is new Mail or Old Mail. 讀取是否為新郵件或舊郵件.
    if([[SelectedRow object] didSelectedRowAboutMail] >=0 && [[SelectedRow object] didSelectedNewOrOldAboutMail]) {
        //準備將讀取的文章內容取出
        content = [NSData new];
        content = putTextViewAddArray[[[SelectedRow object] didSelectedRowAboutMail]];
        //準備將讀取的文章日期給文章內容
        dateLabel.text = putDateAddArray[[[SelectedRow object] didSelectedRowAboutMail]];
        //準備將文章內容放置 TextView
        NSMutableAttributedString *textViewcontent = [NSMutableAttributedString new];
        textViewcontent = (NSMutableAttributedString*)[NSKeyedUnarchiver unarchiveObjectWithData:content];
        _TextView.attributedText = textViewcontent;
        //準備將設定的文章內容 BOOL 值 設定成 True
        [[SelectedRow object]SendSelectedRowAboutMail:[[SelectedRow object] didSelectedRowAboutMail] Bool:false];
        
        popViewOrdimissViewfunc = 1;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // Setting the NaviagtionBar BackGroundColor to CleanColor. 設定NaviagtionBar 為透明.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    //準備讀取儲存的資料
    defaults = [NSUserDefaults standardUserDefaults];
    //準備設定 Frame
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    //準備設定 View 的背景顏色
    self.view.backgroundColor =[UIColor flatWhiteColorDark];
    //準備設定鍵盤位置通知
    [self registerForKeyboardNotifications];
    //準備設定日期給 TextView
    [self MyWriteMailTableViewPrepare];
    //準備設定鍵盤上的 ToolBar
    [self SetToolbarToAboveKeyboard];
    //準備設定 TextView 設定
    [self TextViewPrepare];
    
}

#pragma mark - Prepare set SendContent by mail 準備傳送內容分享上傳

- (IBAction)SendByMail:(id)sender {
    //準備讀取 _TextView.attributedText 裏的照片
    NSMutableArray *catchImage;
    NSRange range = NSMakeRange(0,_TextView.text.length);
    //準備取出 _TextView.attributedText 裏的照片
    catchImage = [NSMutableArray new];
    [_TextView.attributedText enumerateAttribute:@"NSAttachment" inRange:range
                                         options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                             if(value != nil) {
                                                 NSTextAttachment *imageAttachment = value;
                                                 [catchImage addObject:imageAttachment.image];
                                             }
                                         }];
    //準備將 objectsToShare 給 UIActivityViewController 值
    NSMutableArray *objectsToShare = [NSMutableArray arrayWithObjects:_TextView.text,nil];
    for (UIImage *image in catchImage) {
        [objectsToShare addObject:image];
    }
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Prepare save Content from Mail 準備儲存文章內容

- (IBAction)SendMessage:(id)sender {
    
    // Ready to all textViewContent give textViewcontent. 準備將 TextView 上的內容給包裝好.
    NSMutableAttributedString *textViewcontent = [[NSMutableAttributedString alloc]
                                                  initWithAttributedString:_TextView.attributedText];
    content = [NSData new];
    content = [NSKeyedArchiver archivedDataWithRootObject:textViewcontent];
    
    // If didSeletedRow is bigger 0 or equal 0, save the content to specify putTextViewArray position. 選擇的如果選擇舊信箱的話，修改信箱內容並儲存。
    if([[SelectedRow object] didSelectedRowAboutMail] >=0) {
        putTextViewAddArray[[[SelectedRow object] didSelectedRowAboutMail]] = content;
        
        NSLog(@"儲存的內容為： %@",putTextViewAddArray);
        
        putTextViewArray[ChildID] = putTextViewAddArray;
        [defaults setValue:putTextViewArray forKey:@"textViewcontent"];
        [defaults synchronize];
        
    // if didSelectedRow is smaller 0, create a new Mail and save. 如果是選擇新信箱的話，創造一個新的資料並儲存。
    } else if([[SelectedRow object] didSelectedRowAboutMail] ==-1){
        
        NSMutableAttributedString *textViewcontent = [[NSMutableAttributedString alloc] initWithAttributedString:_TextView.attributedText];
        
        content = [NSKeyedArchiver archivedDataWithRootObject:textViewcontent];
        NSLog(@"文章的內容為：%@",content);
        
        [putTextViewAddArray addObject:content];
        NSLog(@"儲存的內容為： %@",putTextViewAddArray);
        
        putTextViewArray[ChildID] = putTextViewAddArray;
        [defaults setValue:putTextViewArray forKey:@"textViewcontent"];
        
        [putDateAddArray addObject:dateString];
        
        putDateArray[ChildID] = putDateAddArray;
        NSLog(@"putDateAddArray的內容為： %@",putDateArray);
        
       [defaults setValue:putDateArray forKey:@"Mailibformation"];
        
       [defaults synchronize];
        
    }
    if(popViewOrdimissViewfunc == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Prepare Set PhotoSelect from UIActionSheet 準備 UIActionSheet 選擇相機或相簿功能

- (IBAction)photoselect:(id)sender {
    UIActionSheet *myActionSheet =  [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"相機", @"相簿", nil];
    
    [myActionSheet showInView:self.view];
}

#pragma mark - Prepare Set Cancel UIImagePickerController 準備取消 UIImagePickerController 功能

-(void) CancelPicture {
    [picker dismissViewControllerAnimated:YES completion: NULL];
}

#pragma mark - Prepare Set launchImagePickerWithSourceType 準備啟動相機或相簿功能

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

#pragma mark - Prepare Start to Pick Photo 準備啟動所選擇的相機或相簿功能


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

#pragma mark - Prepare When Photo Picked Editing Photo 準備邊幾所選取的相機或相簿


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
        
        //準備 MyTextAttachment 放置選取的照片
        MyTextAttachment *attachment = [MyTextAttachment new];
        
        if(editImage) {
            attachment.image = editImage;
        } else {
            attachment.image = resizeImage;

        }
        NSAttributedString *attStr = [NSAttributedString new];
        attStr = (NSAttributedString*)[NSAttributedString attributedStringWithAttachment:attachment];
        
        NSMutableAttributedString *textViewcontent = [[NSMutableAttributedString alloc]
                                                      initWithAttributedString:_TextView.attributedText];
        NSRange selectedRange =  _TextView.selectedRange;
        
        [textViewcontent insertAttributedString:attStr atIndex:selectedRange.location];
        
        [textViewcontent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0,textViewcontent.length)];
        
        NSRange newSelctedRange = NSMakeRange(selectedRange.location+10,0);

        _TextView.attributedText = textViewcontent;
        _TextView.selectedRange = newSelctedRange;
        
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

#pragma mark - Prepare to back last page 準備回到上一頁按鍵

- (IBAction)backLastPage:(id)sender {
    
    if(popViewOrdimissViewfunc == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Prepare to resignFirstResponder 準備收起鍵盤

-(void)resgisterKeyborad {
    [_TextView resignFirstResponder];
}

#pragma mark - Prepare to set Toobar and PhotoImage add Keyboard. 準備 Toobar 和 照相圖片加入鍵盤

-(void)SetToolbarToAboveKeyboard {
    
    // Give BackBtn a Image (Arrow38x38@2x.png).
    [_BackBtn setImage:[UIImage imageNamed:@"Arrow38x38@2x.png"]
              forState:UIControlStateNormal];
    
    UIToolbar *test = [UIToolbar new];
    //test.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *Done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resgisterKeyborad)];
    UIBarButtonItem *Camera = [[UIBarButtonItem alloc]
                               initWithImage:[UIImage imageNamed:@"Camera65x65@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(photoselect:)];
    UIBarButtonItem *Video = [[UIBarButtonItem alloc]
                              initWithImage:[UIImage imageNamed:@"Video75x50@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(photoselect:)];
    UIBarButtonItem *flexibleSpaceBarButton1 = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                target:nil
                                                action:nil];
    UIBarButtonItem *flexibleSpaceBarButton2 = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                target:nil
                                                action:nil];
    test.items = [NSArray arrayWithObjects:
                  flexibleSpaceBarButton1,Camera,flexibleSpaceBarButton2,Done, nil];
    [test sizeToFit];
    _TextView.inputAccessoryView = test;
}

#pragma mark - Prepare to set Time add TextView 準備時間顯示加入 TextView

-(void)MyWriteMailTableViewPrepare{
    // Prepare a Time to Print. 準備一個時間顯示給 Label.
    NSDateFormatter *dateFormatter=[NSDateFormatter new];
    NSDateFormatter *dateFormatterToPostCard = [NSDateFormatter new];
    dateString = [NSString new];
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm a"];
    [dateFormatterToPostCard setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    // Prepare a Label to print Date and Time. 準備Label 給 TableView 並顯示時間.
    dateLabel = [[UILabel alloc]
                      initWithFrame:CGRectMake(0, 0, _TextView.frame.size.width, 20)];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    dateLabel.textColor = [UIColor flatGrayColor];
    dateLabel.font = [UIFont fontWithName:@"Arial" size:15];
    dateLabel.backgroundColor = [UIColor flatSandColor];
    //dateLabel.alpha = 1 ;
    dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    dateString = [dateFormatterToPostCard stringFromDate:[NSDate date]];
    _MyWriteMailTableView.tableHeaderView = dateLabel;
    
    _MyWriteMailTableView.backgroundColor = [UIColor flatBlackColor];
    //_MyWriteMailTableView.layer.cornerRadius=15.0;
    //_MyWriteMailTableView.clipsToBounds = YES;
    //_MyWriteMailTableView.layer.borderWidth = 2.0;
    //_MyWriteMailTableView.layer.borderColor = [UIColor flatBlackColor].CGColor;
    //_MyWriteMailTableView.layer.masksToBounds = YES;
    
    _MyWriteMailTableView.layer.shadowOffset = CGSizeMake(5,5);
    _MyWriteMailTableView.layer.shadowRadius = 3.5;
    _MyWriteMailTableView.layer.shadowOpacity = 0.8;
    _MyWriteMailTableView.layer.masksToBounds = false;
    
    _MyWriteMailTableView.scrollEnabled = false;

    
}


#pragma mark - Prepare set TextView 準備設定 TextView 屬性

// 為 TextView 做準備
-(void)TextViewPrepare{
    _TextView.delegate = self;
    // Prepare a TextView to type word for user. 準備一個 TextView 給使用者輸入文字.
    _TextView.font = [UIFont fontWithName:@"Arial" size:18.0];
    _TextView.textColor = [UIColor flatBlackColor];
    _TextView.backgroundColor = [UIColor flatSandColor];
    //_TextView.alpha = 0.1 ;
    //_TextView.backgroundColor=[UIColor flatSandColor];
    //_TextView.layer.cornerRadius=30.0;
    //_TextView.clipsToBounds = YES;
    //_TextView.layer.borderWidth = 2.0;
    //_TextView.layer.borderColor = [UIColor flatBlackColor].CGColor;
    //_TextView.layer.masksToBounds = YES;
    

}


-(BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    return YES;
}


#pragma mark - Prepare set KeyBoard position 準備設定鍵盤位置根據浮標移動

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+50, 0.0);
    _TextView.contentInset = contentInsets;
    _TextView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _TextView.frame.origin) ) {
        [self.TextView scrollRectToVisible:_TextView.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _TextView.contentInset = contentInsets;
    _TextView.scrollIndicatorInsets = contentInsets;
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
