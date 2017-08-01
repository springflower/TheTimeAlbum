//
//  BigStickerSettingViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/24.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "BigStickerSettingViewController.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface BigStickerSettingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *MyBigSticker;
@property (weak, nonatomic) IBOutlet UIButton *PlusBigSticker;

@end

@implementation BigStickerSettingViewController
{
    NSUserDefaults *defaults;
    NSMutableArray <UIImage*>*ImageArray;
}

@synthesize MyBigSticker = MyBigSticker;
@synthesize PlusBigSticker = PlusBigSticker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ImageArray = [NSMutableArray new];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"大頭貼";
    
    [self SettingButton];
    
    [self SettingMyBigStickerAndPlusBigSticker];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// When Button Press Go to PhotoLibrary.
- (IBAction)PlusBigSticker:(id)sender {
    [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
// Start to Pick Photo and Save.
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
        
         MyBigSticker.image = editImage;
        
        
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


// Go Back the Last Page.
-(void)BackToSetting {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    //[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
   
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)FinishButton {
    [ImageArray addObject:MyBigSticker.image];
    //[defaults setValue:ImageArray forKey:@"image"];
    [defaults setObject:UIImagePNGRepresentation(MyBigSticker.image) forKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dimssAddChildSettingViewController" object:nil];
}
// Set BigStickerPlusSticker
-(void) SettingMyBigStickerAndPlusBigSticker {
    MyBigSticker.layer.cornerRadius=50.0;
    MyBigSticker.clipsToBounds = YES;
    MyBigSticker.layer.borderWidth = 3.0;
    MyBigSticker.layer.borderColor = [UIColor whiteColor].CGColor;
    MyBigSticker.layer.masksToBounds = YES;
    
    PlusBigSticker.layer.cornerRadius=15.0;
    PlusBigSticker.clipsToBounds = YES;
    PlusBigSticker.layer.borderWidth = 3.0;
    PlusBigSticker.layer.borderColor = [UIColor whiteColor].CGColor;
    PlusBigSticker.layer.masksToBounds = YES;
}

-(void) SettingButton {
    UIBarButtonItem *Cancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:
                               UIBarButtonItemStyleDone target:self action:@selector(BackToSetting)];
    self.navigationItem.leftBarButtonItem = Cancel;
    
    UIBarButtonItem *Finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:
                               UIBarButtonItemStyleDone target:self action:@selector(FinishButton)];
    self.navigationItem.rightBarButtonItem = Finish;
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
