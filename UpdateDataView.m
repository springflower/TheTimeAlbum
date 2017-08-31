//
//  UpdateDataView.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/20.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import <AFNetworking.h>
#import "UpdateDataView.h"
#import "UseDownloadDataClass.h"
#import <ChameleonFramework/Chameleon.h>
#import "AddChildSettingViewController.h"

@interface UpdateDataView()<UIApplicationDelegate>

@end

@implementation UpdateDataView

{
    //準備讀取大頭貼資料
    NSArray *ChildBigStickerArray;
    //準備更新動畫
    UIActivityIndicatorView *loadingIndicatorView;
    //準備使用儲存的資料
    NSUserDefaults *defaults;
    //準備讀取孩子名字陣列
    
}



#pragma mark - Prepare the Setting View  準備設定使用 View 設定的初始值

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    //開始上傳資料並設定更新動畫執行
    UILabel *updatedescription =
    [[UILabel alloc] initWithFrame:CGRectMake(0,50,
                                              frame.size.width,frame.size.height)];
    [updatedescription setText:@"更新中."];
    [updatedescription setTextColor:[UIColor flatSkyBlueColor]];
    updatedescription.backgroundColor = [UIColor clearColor];
    updatedescription.textAlignment = NSTextAlignmentCenter;

    CGRect subViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingIndicatorView.color = [UIColor flatSkyBlueColor];
    loadingIndicatorView.hidesWhenStopped = true;
    loadingIndicatorView.frame = subViewFrame;
    loadingIndicatorView.backgroundColor = [UIColor flatWhiteColor];
    [loadingIndicatorView addSubview:updatedescription];
    [self addSubview:loadingIndicatorView];
    
    return self;
}


#pragma mark - Prepare to download data 準備一個方法下載網路上的資料

-(void)DowloadChildBigSticker:(PassValueBlock)Array {
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        //準備要進行連線的設定
        AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //準備一個陣列讀取下載的資料
        ChildBigStickerArray = [NSArray new];
        //準備要上傳的網址
        NSString *urlDownload =
        [NSString stringWithFormat:@"https://f26681605.000webhostapp.com/textViewArrayDownload.php"];
        //開始執行更新資料動畫
        //[loadingIndicatorView startAnimating];
        
        //設定準備讀取存取在 UserDefaults 的資料
        defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *parmas;
        //準備上傳新增的資料
        if([defaults objectForKey:@"userMail"] != 0) {
            parmas = @{
                       @"userName" :[defaults objectForKey:@"userMail"],};
            NSLog(@"列陣的資料為： %@",parmas);
}
        
        //準備上傳以 POST 封包上傳
        [manager POST:urlDownload parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {} progress:^(NSProgress * _Nonnull uploadProgress) {}
         
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSLog(@"  成功下載資料 ");
             NSLog(@"下載的資料為： %@",responseObject);
             //準備將下載到的資料解除封包
             ChildBigStickerArray = [NSKeyedUnarchiver unarchiveObjectWithData:responseObject];
             //如果 Array 存在，將值傳送給 Block
             if(Array) {
                 Array(ChildBigStickerArray);
             }
             //將動畫執行 View 給隱藏
             self.hidden = true ;
             //停止執行更新動畫
             //[loadingIndicatorView stopAnimating];
             
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"  下載資料失敗 ");
             NSLog(@"原因： %@",error);
             //將動畫執行 View 給隱藏
             self.hidden = true ;
             //停止執行更新動畫
             //[loadingIndicatorView stopAnimating];
             //準備發送通知重新下載資料
             [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadDataFromServe" object:nil];
             
         }];
        
    });
    

    
    
}

#pragma mark - Prepare update data 準備一個方法上傳資料

-(void)UpdataChildBigsticker:(NSArray*)Array {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //將大頭貼陣列轉換成 Data
        NSData *ChildBigStickerArraydata = [NSKeyedArchiver archivedDataWithRootObject:Array];
        NSString *urlUpdate = [NSString
                               stringWithFormat:@"https://f26681605.000webhostapp.com/textViewArrayUpdate.php"];
        //設定準備讀取存取在 UserDefaults 的資料
        defaults = [NSUserDefaults standardUserDefaults];
        //準備將大頭貼轉換成 base64
        NSString *Covert64Image;
        //準備目前所新增的孩子最新 ID
        NSString *ChildID = [NSString stringWithFormat:@"%lu",Array.count-1];
        if(Array.count != 0) {
            Covert64Image = [[Array lastObject] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
        NSArray *readChildInformationArray = [[UseDownloadDataClass object] ReadChildInformationArray];
        NSDictionary *parmas;
        if([defaults objectForKey:@"userName"] != nil) {
            parmas = @{
                       @"userName" :[defaults objectForKey:@"userMail"],
                       @"userChildID"          :ChildID,
                       @"childName"            :readChildInformationArray[0],
                       @"childBirthday"        :readChildInformationArray[1],
                       @"childSex"             :readChildInformationArray[2],
                       @"withChildRelationship":readChildInformationArray[3],
                       @"ChildBigStickerData" : Covert64Image
                                     };
            
        }

        [manager POST:urlUpdate parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            

            //準備上傳資料的 Key 名稱
            [formData appendPartWithFormData:ChildBigStickerArraydata name:@"updateChildBigStickerArray"];
            
            [loadingIndicatorView startAnimating];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //..
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"  成功上傳資料 ");
            NSLog(@"putMyBigStickerArray的數量為：  %lu",(unsigned long)Array.count);
            NSLog(@"收到都數據為為：  %@",responseObject);
            //將動畫執行 View 給隱藏
            self.hidden = true ;
            //停止執行更新動畫
            [loadingIndicatorView stopAnimating];
            //設定當上傳成功時傳值共用資料
            [[UseDownloadDataClass object] PutChildBigStickerArray:Array];
            
            if(Array.count != 0) {
                //設定通知結束 BigStickerSettingViewController 並儲存資料
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"BigStickerSettingViewController" object:nil];
                //設定通知結束 SetInfoTableViewControler 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SetInfoTableViewControler" object:nil];
                //通知執行 SliderMenuViewLeft 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"updateTableViewContrler" object:nil];
                //設定通知結束 FutureMailViewController 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"FutureMailViewController" object:nil];
                //如果讀出的陣列數量為零的話，就執行 AddChildSettingViewController 來創造第一個孩子。
                NSLog(@"Array.count: %lu",(unsigned long)Array.count);
                //準備發送通知 PopSetInfoTableViewControler 結束
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopSetInfoTableViewControler" object:nil];
            } else {
                //準備發送通知 PopSetInfoTableViewControler 結束
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopSetInfoTableViewControler" object:nil];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"  上傳資料失敗 ");
            
            
            NSLog(@"原因： %@",error);
            //將動畫執行 View 給隱藏
            self.hidden = true ;
            //停止執行更新動畫
            [loadingIndicatorView stopAnimating];
            
        }];
        
    });
    
}


#pragma mark - Prepare update data 準備一個方法上傳資料後更新本機的資料

-(void)UpdataChildBigstickerIfUseChangeunction:(NSArray*)Array {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:Array];
        NSString *urlUpdate = [NSString
                               stringWithFormat:@"https://f26681605.000webhostapp.com/sqlUpdateData.php"];
        AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //設定準備讀取存取在 UserDefaults 的資料
        defaults = [NSUserDefaults standardUserDefaults];
        NSInteger ChildIDIInteger = [defaults integerForKey:@"ChildID"];
        NSString  *ChildID = [NSString stringWithFormat:@"%ld",(long)ChildIDIInteger];
        NSLog(@"目前的 ID 為 ： %ld",(long)ChildID);
        NSArray *readChangeChildInfoArray = [[UseDownloadDataClass object] ReadChangeChildInformationArray];
        //準備將圖片轉為base64
        NSString *Covert64Image;
        if(Array.count != 0) {
           Covert64Image = [[Array objectAtIndex:ChildIDIInteger] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

        }

        NSDictionary *parmas = @{
                                 @"userName" :[defaults objectForKey:@"userMail"],
                                 @"userChildID":ChildID,
                                 @"childName" : [readChangeChildInfoArray objectAtIndex:0],
                                 @"childBirthday" :[readChangeChildInfoArray objectAtIndex:1],
                                 @"ChildBigStickerData" : Covert64Image
                                 };
        
        [manager POST:urlUpdate parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //準備上傳資料的 Key 名稱
            [formData appendPartWithFormData:data name:@"updateChildBigStickerArray"];
            //將成功上傳的的孩子大頭貼陣列資料傳到全域變數來使用
            
            [loadingIndicatorView startAnimating];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //..
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"  成功上傳資料 ");
            NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"putMyBigStickerArray的數量為：  %@",json);
            
            
            //將動畫執行 View 給隱藏
            self.hidden = true ;
            //停止執行更新動畫
            [loadingIndicatorView stopAnimating];
            //設定當上傳成功時傳值共用資料
            [[UseDownloadDataClass object] PutChildBigStickerArray:Array];
            
            //準備通知 SetInfoTableViewControler 可以更新本機資料了
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ChangeDataFromSetInfoTableViewControler" object:nil];
            
            if(Array.count != 0) {
                //設定通知結束 BigStickerSettingViewController 並儲存資料
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"BigStickerSettingViewController" object:nil];
                //設定通知結束 SetInfoTableViewControler 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SetInfoTableViewControler" object:nil];
                //通知執行 SliderMenuViewLeft 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"updateTableViewContrler" object:nil];
                //設定通知結束 FutureMailViewController 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"FutureMailViewController" object:nil];
                //如果讀出的陣列數量為零的話，就執行 AddChildSettingViewController 來創造第一個孩子。
                NSLog(@"Array.count: %lu",(unsigned long)Array.count);
                //準備發送通知 PopSetInfoTableViewControler 結束
                NSLog(@"已通知 PopSetInfoTableViewControler");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopSetInfoTableViewControler" object:nil];
            } else {
                //準備發送通知 PopSetInfoTableViewControler 結束
                NSLog(@"已通知 PopSetInfoTableViewControler");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopSetInfoTableViewControler" object:nil];
            }
            //        AddChildSettingViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"AddChildSettingViewController"];
            //        [self presentViewController:nextPage animated:YES completion:nil];
            //        AddChildSettingViewController *nextPage = [[AddChildSettingViewController alloc] initWithNibName:@"AddChildSettingViewController" bundle:nil];
            //        [self presentModalViewController:nextPage animated:YES ];
            //            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"  上傳資料失敗 ");
            NSLog(@"原因： %@",error);
            //將動畫執行 View 給隱藏
            self.hidden = true ;
            //停止執行更新動畫
            [loadingIndicatorView stopAnimating];
            
        }];
        
    });
    
}


#pragma mark - Prepare update data 準備一個方法上傳後刪除資料

-(void)UpdataChildBigstickerIfUseDeleteFunction:(NSArray*)Array {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:Array];
        NSString *urlUpdate = [NSString
                               stringWithFormat:@"https://f26681605.000webhostapp.com/sqlUpdateDeleteData.php"];
        AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //設定準備讀取存取在 UserDefaults 的資料
        defaults = [NSUserDefaults standardUserDefaults];
        NSInteger ChildIDIInteger = [defaults integerForKey:@"ChildID"];
        NSString  *ChildID = [NSString stringWithFormat:@"%ld",(long)ChildIDIInteger];
        NSDictionary *parmas = @{
                                 @"userName" :[defaults objectForKey:@"userMail"],
                                 @"userChildID":ChildID
                                 };
        
        [manager POST:urlUpdate parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //準備上傳資料的 Key 名稱
            [formData appendPartWithFormData:data name:@"updateChildBigStickerArray"];
            
            
            [loadingIndicatorView startAnimating];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //..
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"  成功上傳資料 ");
            NSLog(@"putMyBigStickerArray的數量為：  %lu",(unsigned long)Array.count);
            //將動畫執行 View 給隱藏
            self.hidden = true ;
            //停止執行更新動畫
            [loadingIndicatorView stopAnimating];
            //設定當上傳成功時傳值共用資料
            [[UseDownloadDataClass object] PutChildBigStickerArray:Array];
            
            //準備通知 SetInfoTableViewControler 可以刪除本機資料了
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"DeleteDataFromSetInfoTableViewControler" object:nil];
            
            //設定如果大頭貼資料不等於空的話才要更新資料
            if(Array.count != 0) {
                //設定通知結束 BigStickerSettingViewController 並儲存資料
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"BigStickerSettingViewController" object:nil];
                //設定通知結束 SetInfoTableViewControler 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SetInfoTableViewControler" object:nil];
                //通知執行 SliderMenuViewLeft 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"updateTableViewContrler" object:nil];
                //設定通知結束 FutureMailViewController 進行更新
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"FutureMailViewController" object:nil];
                //如果讀出的陣列數量為零的話，就執行 AddChildSettingViewController 來創造第一個孩子。
                NSLog(@"Array.count: %lu",(unsigned long)Array.count);
                //準備發送通知 PopSetInfoTableViewControler 結束
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopSetInfoTableViewControler" object:nil];
                
            } else {
                //準備發送通知 PopSetInfoTableViewControler 結束
                NSLog(@"已通知 PopSetInfoTableViewControler");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopSetInfoTableViewControler" object:nil];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"  上傳資料失敗 ");
            NSLog(@"原因： %@",error);
            //將動畫執行 View 給隱藏
            self.hidden = true ;
            //停止執行更新動畫
            [loadingIndicatorView stopAnimating];
            
        }];
        
    });
    
}



@end