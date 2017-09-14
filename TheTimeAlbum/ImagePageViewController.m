//
//  ImagePageViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "ImagePageViewController.h"
#import "ImageViewController.h"
#import <KVNProgress.h>
#import <AFNetworking.h>
#import "MyCommunicator.h"
#import "AddAchievementViewController.h"


@interface ImagePageViewController () <UIPageViewControllerDataSource>
{
    //UIPageViewController *myPageViewController;
    BOOL optionMenuIsUp;
    MyCommunicator *comm;
    NSUserDefaults *localUserData;
    NSInteger allPicsCount;
    NSString * allPhotoStr;
    

}
@property (strong, nonatomic) IBOutlet UIView *myView;

@property (nonatomic,strong) NSMutableArray * viewcontrollers;
@property (nonatomic,strong) UIPageViewController * pageViewController;

@end

@implementation ImagePageViewController

- (void)viewWillAppear:(BOOL)animated {
    
    // 設定選項的 UIView的 Constraint
    [self.view addSubview:self.myView];
    self.myView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.myView.heightAnchor constraintEqualToConstant:128].active = YES;
    [self.myView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10].active = YES;
    [self.myView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10].active = YES;
    NSLayoutConstraint *c = [self.myView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:128];
    c.identifier = @"bottom";
    c.active = YES;
    
    [super viewWillAppear:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set navigationbar to transparent     設定navbar透明
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems.firstObject.tintColor = [UIColor whiteColor];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    // 初始化某些東東
    self.viewcontrollers = [NSMutableArray new];
    optionMenuIsUp = NO;
    comm = [MyCommunicator sharedInstance];
    allPhotoStr = self.allImageNameStr;
    
    
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
//    singleTap.numberOfTapsRequired = 1;
//    singleTap.cancelsTouchesInView = NO;
//
//    [self.view setUserInteractionEnabled:YES];
//    [self.view addGestureRecognizer:singleTap];
    
    // 選項清單的menu
    UIBarButtonItem *optionBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(callMenu)];
    self.navigationItem.rightBarButtonItem = optionBtn;
    
    
    
    // 每一頁的內容
    UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"ImageViewController" bundle:[NSBundle mainBundle]];
    
    NSArray *picNames = [self.allImageNameStr componentsSeparatedByString:@","];
    //FIXME: 不知道會不會有需要下載的時候
    BOOL shouldDownload = YES;
    
    allPicsCount = picNames.count;
    
    // 用迴圈取得圖的數量並生成相對數量的頁面
    for(int i=0; i<picNames.count; i++){
        NSLog(@"...%@", picNames[i]);
        ImageViewController *ivc = [storyboard2 instantiateViewControllerWithIdentifier:@"ImageViewController"];
        
        NSLog(@"viewcontrollers 2 : %lu", (unsigned long)self.viewcontrollers.count);
        
        NSString *picName = picNames[i];
        NSString *downloadingFilePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"] stringByAppendingPathComponent:picName];
        NSLog(@" pic path name : %@", downloadingFilePath);
        NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
        
        
        // 取得暫存資料夾的圖片 放入每個imageViewController的UIImage裡
        NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"download"];
        NSFileManager *fileM = [NSFileManager defaultManager];
        NSArray * a = [fileM contentsOfDirectoryAtPath:directory error:nil];
        for(NSString *temp in a){
            
            if([picName isEqualToString:temp]){
                UIImage *ii = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadingFileURL]];
                
                if(ii == nil){
                    NSLog(@"aa");
                } else {
                    NSLog(@"bb");
                }
                ivc.thisImage = ii;
                ivc.thisPicName = picName;
            }
        }
        [self.viewcontrollers addObject:ivc];
    }
    
    
    // end of 每一頁的內容


    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"ImagePageViewController" bundle:[NSBundle mainBundle]];
    
    // PageViewController(容器) 初始化
    self.pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    
    //  指定 PageViewController 的 delegate
    self.pageViewController.dataSource = self;
    
    // 準備起始畫面給 pageViewController
    // 取出第一個物件
    ImageViewController *first = [self.viewcontrollers objectAtIndex:0];
    
    // 指派第一個 viewcontroller 物件給 PageViewController
    [self.pageViewController setViewControllers:@[first] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // 將 PageViewController 的畫面加上來
    // 先跟自己說你即將多一個小孩，小孩是 PageViewController
    [self addChildViewController:self.pageViewController];
    // 加入畫面
    [self.view addSubview:self.pageViewController.view];
    // 跟 PageViewController 說你有個爸爸，爸爸是 self
    [self.pageViewController didMoveToParentViewController:self];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 選項相關
- (void) callMenu {
    NSLog(@"find constraints...?");
    //ImageViewController *ivcTemp = [self.ivcs objectAtIndex:0];
    
    if (!optionMenuIsUp) {
        for (NSLayoutConstraint *c in self.view.constraints) {
            if ( [c.identifier  isEqual: @"bottom"]) {
                NSLog(@"find constraints...");
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
                NSLog(@"find constraints...");
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
                NSLog(@"find constraints...");
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
// 取消
- (IBAction)onCancelBtnClicked:(UIButton *)sender {
    NSInteger index = [self.viewcontrollers indexOfObject:[self.pageViewController.viewControllers lastObject]];
    NSLog(@"index: %ld", (long)index);
    if ( optionMenuIsUp ){
        [self closeMenu];
    }
}
// 存入相機膠卷
- (IBAction)saveImageToCameraRoll:(UIButton *)sender {
    ImageViewController *thisIVC = [self.pageViewController.viewControllers lastObject];
    UIImage *thisImage = thisIVC.thisImage;
    //UIImageWriteToSavedPhotosAlbum(thisImage, self, @selector(finishDownloadImage), nil);
    UIImageWriteToSavedPhotosAlbum(thisImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    if ( optionMenuIsUp ){
        [self closeMenu];
    }
    
}
- (IBAction)deletePhoto:(UIButton *)sender {
    // 取出當前的viewcontroller並從陣列移除
    ImageViewController *thisIVC = [self.pageViewController.viewControllers lastObject];
    
    BOOL isLast;
    
    // 看看刪掉的是不是最後一項 如果不是 都要刪掉檔名+一個逗號
    NSInteger whitchPage = [self.viewcontrollers indexOfObject:thisIVC];
    // 如果是
    if(whitchPage == allPicsCount-1){
        isLast = YES;
    } else {
        isLast = NO;
    }
    // --
    
    
    NSString *thisPhotoStr = thisIVC.thisPicName;

    NSLog(@"0 \n this: %@\n all: %@", thisPhotoStr, allPhotoStr);
    
    // 如果目前還剩很多張 直接刪掉一張 更新貼文
    if (self.viewcontrollers.count > 1) {
        
        
        if(isLast){
            
            if (allPicsCount == 1){
                // 如果刪掉的圖是post中的最後一個 刪掉檔名即可
                
            } else {
                // 如果要刪的圖是最後一個 但前面還有其他張, 要刪掉",檔名.jpg"
                NSString *temp = @",";
                thisPhotoStr = [temp stringByAppendingString:thisPhotoStr];
                
            }
            allPhotoStr = [allPhotoStr stringByReplacingOccurrencesOfString:thisPhotoStr withString:@""];
            NSLog(@"1 \n this: %@\n final: %@", thisPhotoStr, allPhotoStr);
            
            allPicsCount -= 1;
            
            
        } else {
            // 如果刪掉的圖不是post中的最後一個 那就要刪掉檔名+,
            NSString *tempStr = [thisPhotoStr stringByAppendingString:@","];
            allPhotoStr = [allPhotoStr stringByReplacingOccurrencesOfString:tempStr withString:@""];
            NSLog(@"2 \n this: %@\n final: %@", thisPhotoStr, allPhotoStr);
            allPicsCount -= 1;
            
        }
        
        [self.viewcontrollers removeObject:thisIVC];
        
        NSInteger postType=0;
        
        if (allPicsCount >= 3) {
            postType = 4;
        } else if (allPicsCount == 2) {
            postType = 3;
        } else if (allPicsCount == 1) {
            postType = 2;
        }
        
        
        // 更新貼文的內容
        [self updatePostByPostID:self.postID andPostType:postType theContentOfPost:allPhotoStr];

        
    } else if (self.viewcontrollers.count == 1) {
        // 只剩一張還要刪除的話 刪除整個貼文, 回主畫面
        [allPhotoStr stringByReplacingOccurrencesOfString:thisPhotoStr withString:@""];
        //NSLog(@"3 \n this: %@\n final: %@", thisPhotoStr, allPhotoStr);
        allPicsCount -= 1;
        //NSLog(@" post id: %ld", self.postID);
        [comm deletePostByPostID:self.postID completion:^(NSError *error, id result) {
            
            // 測試error
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doReloadJob" object:nil];
        }];
        
        // 廣播主頁重整
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    

    
     // 重新指派剩下陣列中第一個 viewcontroller 物件給 PageViewController重新載入
    ImageViewController *first = [self.viewcontrollers objectAtIndex:0];
    [self.pageViewController setViewControllers:@[first] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    
    
}
// 新增成就
- (IBAction)addAchievement:(UIButton *)sender {
    
    ImageViewController *thisIVC = [self.pageViewController.viewControllers lastObject];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddAchievement" bundle:[NSBundle mainBundle]];
    
    AddAchievementViewController *goAddAchievementPage = [storyboard instantiateViewControllerWithIdentifier:@"AddAchievementViewController"];
    
    // 要給下一頁的資料
    NSString *tt = thisIVC.thisPicName;
    NSLog(@"%@,,,,,,", tt);
    goAddAchievementPage.thisPicName = tt;
    goAddAchievementPage.thisImage = thisIVC.thisImage;
    
    if ( optionMenuIsUp ){
        [self closeMenu];
    }
    //goAddAchievementPage.achievementImage.image = thisIVC.thisImage;
    //[self presentViewController:goAddAchievementPage animated:YES completion:nil];
    [self.navigationController pushViewController:goAddAchievementPage animated:YES];
    
}

// 儲存圖片成功
- (void) finishDownloadImage {


}
//FIXME: 改成不需要按確定鈕比較好
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    UIAlertView *alert;
    
    //以error參數判斷是否成功儲存影像
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"錯誤"
                                           message:[error description]
                                          delegate:self
                                 cancelButtonTitle:@"確定"
                                 otherButtonTitles:nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"成功"
                                           message:@"影像已存入相簿中"
                                          delegate:self
                                 cancelButtonTitle:@"確定"
                                 otherButtonTitles:nil];
    }
    //顯示警告訊息
    [alert show];
}





#pragma mark - end of 選項相關


#pragma mark - 網路通訊

- (void) updatePostByPostID: (NSInteger)PostID andPostType:(NSInteger)PostType theContentOfPost:(NSString*)content {
    //FIXME: 更新時要依據剩下圖片數量改變postType && 刪除aws s3的圖片？
    [comm updatePostsToServerWithPostID:PostID
                               postType:PostType
                                content:content
                             completion:^(NSError *error, id result) {
                                 
                                 if(error){
                                     NSLog(@"更新貼文失敗: %@.. 重試", error);
                                     [self updatePostByPostID:PostID andPostType:PostType theContentOfPost:content];
                                     return;
                                 }
                                 NSLog(@"==--%@", result);
                                 // 伺服器php指令是否成功
                                 if([result[RESULT_KEY] boolValue] == false){
                                     NSLog(@"更新貼文時伺服器端php錯誤: %@", result[ERROR_CODE_KEY]);
                                     [self updatePostByPostID:PostID andPostType:PostType theContentOfPost:content];
                                     return;
                                 }

                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"doReloadJob" object:nil];
                                 // fix here...
                                 
                                 
                             }];

}








#pragma mark - UIPageViewController Datasource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    // 檢查使用者目前看到的畫面，是在我們陣列裡面的第幾個物件
    NSInteger index = [self.viewcontrollers indexOfObject:viewController];
    
    // 如果使用者看到的畫面是陣列裡的第 0 個，或是找不到的話，就回傳 nil
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    
    // 如果非以上狀況，代表前面有東西可以顯示，故將 index-1
    index--;
    return [self.viewcontrollers objectAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    // 檢查使用者目前看到的畫面，是在我們陣列裡面的第幾個物件
    NSInteger index = [self.viewcontrollers indexOfObject:viewController];
    
    // 如果找不到的話，就回傳 nil
    if (index == NSNotFound) {
        return nil;
    }
    
    // 將 index+1，準備拿下一個 viewcontroller 物件
    index++;
    
    // 在拿之前，先確認一下沒有超過陣列的範圍，否則會 crash。如果超過的話，回傳 nil
    if (index == [self.viewcontrollers count]) {
        return nil;
    }
    
    return [self.viewcontrollers objectAtIndex:index];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.viewcontrollers count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}





@end
