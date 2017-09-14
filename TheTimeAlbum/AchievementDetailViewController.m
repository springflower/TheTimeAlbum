//
//  AchievementDetailViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/9/14.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "AchievementDetailViewController.h"
#import <Chameleon.h>
#import <KVNProgress.h>
#import <AWSS3.h>
#import "MyCommunicator.h"

@interface AchievementDetailViewController ()
{
    NSInteger achievementID;
    MyCommunicator *comm;
}
@end

@implementation AchievementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    comm = [MyCommunicator sharedInstance];
    [self initUI];
    
    // 創建本地暫存資料夾
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"]
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
        NSLog(@"Creating 'download' directory failed. Error: [%@]", error);
    }
}

#pragma mark - 調整navigation bar item
- (void) initUI {
    
    self.navigationController.navigationBar.tintColor = [UIColor flatOrangeColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: (247/255.0) green:217/255.0 blue:173/255.0 alpha:0.54];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *rightOptionsBtn = [[UIBarButtonItem alloc] initWithTitle:@"選項"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(goOptions)];

    NSArray *arrayOfItems = [[NSArray alloc] initWithObjects:rightOptionsBtn, nil];
    self.navigationItem.rightBarButtonItems = arrayOfItems;
    self.navigationItem.leftBarButtonItem = nil;
    
    achievementID = self.thisAchievementItem.achievementId;
    self.titleLabel.text = self.thisAchievementItem.achievementTitle;
    NSString *displayString = [NSString stringWithFormat:@"%@, %@",self.thisAchievementItem.achievementFinalDateString, self.thisAchievementItem.achievementCreatDate];
    
    self.dateLabel.text = displayString;
    //self.picImageView.image = self.thisAchievementItem
    [self setImage];
    
    NSLog(@" 成就ID: %ld, title: %@", achievementID, self.thisAchievementItem.achievementTitle);
    
    
    //self.contentTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"diaryBG2"]];
}
- (void) goOptions {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"選項" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"刪除成就" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //[self configKVNProgress];
        [KVNProgress show];
//        [comm deletePostByPostID:self.postID completion:^(NSError *error, id result) {
        [comm deleteAchievementByID:self.thisAchievementItem.achievementId
                         completion:^(NSError *error, id result) {
                             if (error) {
                                 [KVNProgress showErrorWithStatus:@"刪除失敗"];
                                 return;
                             }
                             
                             [KVNProgress showSuccessWithStatus:@"刪除成功"];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"NewAchievementAdded" object:nil];
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
//        }];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setImage {
    NSString *picName = self.thisAchievementItem.achievementPicName;
    
    NSString *downloadingFilePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"] stringByAppendingPathComponent:picName];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    
    
        // 檢查圖片是否已暫存 是的話就不下載
        NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"download"];
        NSFileManager *fileM = [NSFileManager defaultManager];
        NSArray * a = [fileM contentsOfDirectoryAtPath:directory error:nil];
        for(NSString *temp in a){
            
            if([picName isEqualToString: temp]){
                NSLog(@"- - 成就圖片已存在: %@", temp);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 將已有暫存的圖顯示在畫面上
                    self.picImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadingFileURL]];
                });
                return;
                break;
                
            }
        }
    
        
        AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new ];
        downloadRequest.bucket = @"the.timealbum";
        downloadRequest.key = picName;
        downloadRequest.downloadingFileURL = downloadingFileURL;
        
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        [[transferManager download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id _Nullable(AWSTask * _Nonnull task) {
            if(task.error){
                
                
            }
            
            if (task.result) {
                // 印出本地下載暫存路徑中的檔案名稱
                NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"download"];
                NSFileManager *fileM = [NSFileManager defaultManager];
                NSArray * a = [fileM contentsOfDirectoryAtPath:directory error:nil];
//                for(NSString *temp in a){
//                    NSLog(@"- - temp: %@", temp);
//                }
                NSLog(@" - - - -成就圖片 download success....");
                

               
            }
            return nil;
        }];


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
