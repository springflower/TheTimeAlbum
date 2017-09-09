//
//  BigStickerSettingViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/24.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import <AFNetworking.h>
#import <Photos/Photos.h>
#import "UpdateDataView.h"
#import "UseDownloadDataClass.h"
#import <ChameleonFramework/Chameleon.h>
#import "BigStickerSettingViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BigStickerSettingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *MyBigSticker;
@property (weak, nonatomic) IBOutlet UIButton *PlusBigSticker;

@end

@implementation BigStickerSettingViewController
{
    //準備讀取所儲存的資料
    NSUserDefaults *defaults;
    //準備讀取儲存的孩子大頭貼陣列
    NSMutableArray *putMyBigStickerArray;
    //準備上傳資料使用
    UpdateDataView *updateChildBigstickerArray;
}

@synthesize MyBigSticker = MyBigSticker;
@synthesize PlusBigSticker = PlusBigSticker;

-(void)viewDidAppear:(BOOL)animated {
    
    updateChildBigstickerArray = [[UpdateDataView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [[UIApplication sharedApplication].delegate.window addSubview:updateChildBigstickerArray];
    updateChildBigstickerArray.hidden = true;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //設定 NavigationBar 的標題
    self.navigationItem.title = @"大頭貼";
    //準備讀取已儲存的資料
    defaults = [NSUserDefaults standardUserDefaults];
    //設定 View 本身的背景顏色
    self.view.backgroundColor = [UIColor lightGrayColor];
    //準備 NavigationBar 上的按鈕
    [self SettingButton];
    //準備顯示在 View 上的 UIImageView 給孩子大頭貼
    [self SettingMyBigStickerAndPlusBigSticker];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndingThisPageAndLastPage)
                                                 name:@"BigStickerSettingViewController" object:nil];
}

#pragma mark - Preare to use PhotoLobibrary 準備使用相簿功能或相機功能

// When Button Press Go to PhotoLibrary. 準備當按鈕按下時，執行相簿選擇
- (IBAction)PlusBigSticker:(id)sender {
    [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
// Start to Pick Photo and Save. //準備當按下時，執行的類型是啟動相簿功能還是相機
-(void) launchImagePickerWithSourceType:(UIImagePickerControllerSourceType) sourceType {
    
    //Check if source type avaulable.
    if([UIImagePickerController isSourceTypeAvailable:sourceType] == false) {
        NSLog(@"Invalid Source Type");
        return;
    }
    // Prepare ImagePicker
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = sourceType;
    //    picker.mediaTypes = @[@"public.image",@"public.movie"];
    picker.mediaTypes = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeMovie];
    picker.delegate = self;
    
    if(sourceType == UIImagePickerControllerSourceTypeCamera) {
        // Prepare Camera Overlay View.
        picker.showsCameraControls = false;
        
        // Prepare a button.
        UIButton *takeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        takeBtn.frame = CGRectMake(0, 20, 80, 30);
        [takeBtn setTitle:@"Take" forState:UIControlStateNormal];
        [takeBtn addTarget:picker action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [picker.cameraOverlayView addSubview:takeBtn];
    } else {
        picker.allowsEditing = true;
    }
    picker.allowsEditing = true;
    
    [self presentViewController:picker animated:true completion:nil];
}

// When Photo Picked Editing Photo 準備編輯所選取的照片並存取
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
        
         MyBigSticker.image = editImage;
        
        NSData *saveImage = UIImageJPEGRepresentation(editImage, 100);
        [defaults setObject:saveImage forKey:@"currentBabyImage"];
        
        
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

#pragma mark - Setting to back last page 設定準備回到上一頁功能

// Go Back the Last Page.
-(void)BackToSetting {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Setting dismiss this View and use NSNotificationCenter Save data 設定完成後結束 BigStickerSettingViewController 並使用通知來出存資料

-(void)EndingThisPageAndLastPage {
    //設定結束這一頁
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveChildInformation" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dimssAddChildSettingViewController" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DimissStartCreateFirstChildViewController" object:nil];
}

#pragma mark - Setting if findished save data and update 設定完成後儲存資料並上傳

-(void)FinishButton {
    //通知儲存要上傳的孩子資訊資料
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveUpdateChildInformation" object:nil];
    //準備讀取下載的孩子大頭貼陣列
    if([[UseDownloadDataClass object] ReadChildBigStickerArray].count != 0) {
        putMyBigStickerArray  = [[NSMutableArray alloc]
                                 initWithArray:[[UseDownloadDataClass object] ReadChildBigStickerArray]];
    } else {
        putMyBigStickerArray = [NSMutableArray new];
    }
    
    updateChildBigstickerArray.hidden = false;
    //將孩子的大頭貼照片轉成 Data 後，再進行儲存資料的動作
    NSData* MyChildBigStickerData = [NSData dataWithData:UIImagePNGRepresentation(MyBigSticker.image)];
    [putMyBigStickerArray addObject:MyChildBigStickerData];
    //將儲存的的孩子大頭貼陣列資料上傳進行更新
    [updateChildBigstickerArray UpdataChildBigsticker:putMyBigStickerArray];
    
}

#pragma mark - Setting UIimageView add self view 設定 ImageView 並加到 View 上面

// Set BigStickerPlusSticker
-(void) SettingMyBigStickerAndPlusBigSticker {
    MyBigSticker.layer.cornerRadius=MyBigSticker.frame.size.width/2;
    MyBigSticker.clipsToBounds = YES;
    MyBigSticker.layer.borderWidth = 3.0;
    MyBigSticker.layer.borderColor = [UIColor whiteColor].CGColor;
    MyBigSticker.layer.masksToBounds = YES;
    
    PlusBigSticker.layer.cornerRadius=PlusBigSticker.frame.size.width/2;
    PlusBigSticker.clipsToBounds = YES;
    PlusBigSticker.layer.borderWidth = 3.0;
    PlusBigSticker.layer.borderColor = [UIColor whiteColor].CGColor;
    PlusBigSticker.layer.masksToBounds = YES;
}

#pragma mark - Setting Button add NavigationBar 設定按鈕到 NavigationBar 上面

-(void) SettingButton {
    UIBarButtonItem *Cancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:
                               UIBarButtonItemStyleDone target:self action:@selector(BackToSetting)];
    self.navigationItem.leftBarButtonItem = Cancel;
    
    UIBarButtonItem *Finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:
                               UIBarButtonItemStyleDone target:self action:@selector(FinishButton)];
    self.navigationItem.rightBarButtonItem = Finish;
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
