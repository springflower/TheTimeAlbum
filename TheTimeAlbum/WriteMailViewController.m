//
//  WriteMailViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/31.
//  Copyright © 2017年 Greathard. All rights reserved.
//
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
    UIImagePickerController *picker;

    UILabel *dateLabel;

    NSMutableArray *putDateArray;
    
    NSMutableArray *putTextViewArray;
    
    NSUserDefaults *defaults;
    NSString *dateString;
    
    NSData *content;
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"%d",[[SelectedRow object]didSelectedRow]);
    
    // Read DateArrayContent 讀取存取的日期陣列.
    NSArray *readDateArray = [defaults objectForKey:@"Mailibformation"];
    
    if(readDateArray) {
        putDateArray  = [readDateArray mutableCopy];
    } else {
        putDateArray = [NSMutableArray new];
    }
    
    // Read TextViewArrayContent 讀取存取的信箱內容.
    NSArray *readTextViewArray = [defaults objectForKey:@"textViewcontent"];
    
    if(readTextViewArray) {
        putTextViewArray = [readTextViewArray mutableCopy];
    } else {
        putTextViewArray = [NSMutableArray new];
    }
    
    // Read is new Mail or Old Mail. 讀取是否為新郵件或舊郵件.
    if([[SelectedRow object] didSelectedRow] >=0 && [[SelectedRow object] didSelectedNewOrOld]) {
        
        content = [NSData new];
        content = readTextViewArray[[[SelectedRow object] didSelectedRow]];
        
        NSMutableAttributedString *textViewcontent = [NSMutableAttributedString new];
        textViewcontent = (NSMutableAttributedString*)[NSKeyedUnarchiver unarchiveObjectWithData:content];
        
        _TextView.attributedText = textViewcontent;
        
        [[SelectedRow object]SendSelectedRow:[[SelectedRow object] didSelectedRow] Bool:false];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting the NaviagtionBar BackGroundColor to CleanColor. 設定NaviagtionBar 為透明.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    defaults = [NSUserDefaults standardUserDefaults];

    fullScreenBounds=[[UIScreen mainScreen] bounds];
    
    self.view.backgroundColor =[UIColor flatWhiteColorDark];
    
    [self registerForKeyboardNotifications];
    
    [self MyWriteMailTableViewPrepare];
    
    [self SetToolbarToAboveKeyboard];
    
    [self TextViewPrepare];
    
}


- (IBAction)SendByMail:(id)sender {
    
    NSMutableAttributedString *textViewcontent = [[NSMutableAttributedString alloc]
                                                  initWithAttributedString:_TextView.attributedText];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:textViewcontent];
    UIImage *myimage = [[UIImage alloc] initWithData:data];
    
    NSArray *objectsToShare = [NSArray arrayWithObjects:_TextView.attributedText, nil];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)SendMessage:(id)sender {
    
    // Ready to all textViewContent give textViewcontent. 準備將 TextView 上的內容給包裝好.
    NSMutableAttributedString *textViewcontent = [[NSMutableAttributedString alloc]
                                                  initWithAttributedString:_TextView.attributedText];
    
    content = [NSData new];
    content = [NSKeyedArchiver archivedDataWithRootObject:textViewcontent];
    
    // If didSeletedRow is bigger 0 or equal 0, save the content to specify putTextViewArray position. 選擇的如果選擇舊信箱的話，修改信箱內容並儲存。
    if([[SelectedRow object] didSelectedRow] >=0) {
        putTextViewArray[[[SelectedRow object] didSelectedRow]] = content;
        
        NSLog(@"儲存的內容為： %@",putTextViewArray);
        
        [defaults setValue:putTextViewArray forKey:@"textViewcontent"];
        [defaults synchronize];
        
    // if didSelectedRow is smaller 0, create a new Mail and save. 如果是選擇新信箱的話，創造一個新的資料並儲存。
    } else if([[SelectedRow object] didSelectedRow] ==-1){
        
        NSMutableAttributedString *textViewcontent = [[NSMutableAttributedString alloc] initWithAttributedString:_TextView.attributedText];
        
        content = [NSKeyedArchiver archivedDataWithRootObject:textViewcontent];
        
        NSLog(@"文章的內容為：%@",content);
        
        [putTextViewArray addObject:content];
        
        NSLog(@"儲存的內容為： %@",putTextViewArray);
        
        [defaults setValue:putTextViewArray forKey:@"textViewcontent"];
        
        [putDateArray addObject:dateString];
        
        [defaults setValue:putDateArray forKey:@"Mailibformation"];
        
        [defaults synchronize];
    }

      //Set Animation to self ViewController
      //CATransition* transition = [CATransition animation];
      //transition.duration = 0.2;
      //transition.type = kCATransitionPush;
      //transition.subtype = kCATransitionFromLeft;
      //[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
      //[self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)photoselect:(id)sender {
    UIActionSheet *myActionSheet =  [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"相機", @"相簿", nil];
    
    [myActionSheet showInView:self.view];
}

-(void) CancelPicture {
    [picker dismissViewControllerAnimated:YES completion: NULL];
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
        
        //Save resizeImage into Photo Library.
        
        PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
        [library performChanges:^{
            
            [PHAssetChangeRequest creationRequestForAssetFromImage:resizeImage];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if(success) {
                NSLog(@"Save Image OK.");
            } else {
                NSLog(@"Save Image Fail: %@",error);
            }
            
        }];
        
        
        NSData *jpgData = UIImageJPEGRepresentation(resizeImage, 0.8);
        NSData *pngData = UIImagePNGRepresentation(resizeImage);
        
        NSLog(@"JPG Data: %lu",jpgData.length);
        NSLog(@"PNG Data: %lu",pngData.length);
        
        
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
        
        //[_TextView.textStorage appendAttributedString:attachmentString];
        //[_TextView setFont:[UIFont fontWithName:@"Arial" size:22]];
        
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

- (IBAction)backLastPage:(id)sender {
//        CATransition* transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromLeft;
//        //[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//        [self.view.window.layer addAnimation:transition forKey:kCATransition];
//    NSLog(@"haha");
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void)resgisterKeyborad {
    [_TextView resignFirstResponder];
}

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
                  Video,flexibleSpaceBarButton1,Camera,flexibleSpaceBarButton2,Done, nil];
    [test sizeToFit];
    _TextView.inputAccessoryView = test;
}

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
    dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    dateString = [dateFormatterToPostCard stringFromDate:[NSDate date]];
    _MyWriteMailTableView.tableHeaderView = dateLabel;
    
    _MyWriteMailTableView.backgroundColor = [UIColor flatSandColor];
}

-(void)TextViewPrepare{
    _TextView.delegate = self;
    
    // Prepare a TextView to type word for user. 準備一個 TextView 給使用者輸入文字.
    _TextView.backgroundColor=[UIColor flatSandColor];
    _TextView.font = [UIFont fontWithName:@"Arial" size:18.0];
    _TextView.textColor = [UIColor flatBlackColor];
}

// Call this method somewhere in your view controller setup code.
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



//-(void)textViewDidChange:(UITextView *)textView {
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    
//    paragraphStyle.lineSpacing = 20;
//    
//    NSDictionary *attributes = @{
//                                 
//                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
//                                 
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 
//                                 };
//    
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
//}


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
