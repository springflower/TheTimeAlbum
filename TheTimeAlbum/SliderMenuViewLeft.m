//
//  SliderMenuView.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import "UseDownloadDataClass.h"
#import "ViewController.h"
#import "SliderMenuViewLeft.h"
#import <ChameleonFramework/Chameleon.h>
#import "SliderMenuLeftTableViewCell.h"
#import "AddChildSettingViewController.h"
#import "UpdateDataView.h"
#define MYCHILDNAME @"我的孩子"

@implementation SliderMenuViewLeft
{
    //準備手指觸控的最後位置
    CGPoint lastLocation;
    //準備一個值取得螢幕本身的寬與高
    CGRect fullScreenBounds;
    //準備一個 TableView 給 View 本身
    UITableView *MenuTableView;
    //準備一個 ID 來取得所選取的孩子
    int targetPageID;
    //準備準備取得的資料
    NSUserDefaults *defaults;
    //準備觸控事件
    UIPanGestureRecognizer *putWayLeftMenu;
    //準備讀取大頭貼陣列
    NSArray *readChildBigStickerArray;
    //準備讀取孩子名字陣列
    NSArray *readChildTextFieldnameArray;
    //準備讀取孩子生日陣列
    NSArray *readChildBirthdayFieldArray;
    //下載的方法來取得資料
    UpdateDataView *downloadChildBigSticker;
    
    NSArray *childNames;
    NSArray *childBirthdays;
    NSArray *childPics;
    NSArray *childIDs;
    //準備準備取得的資料
    NSUserDefaults *localUserData;
    
}
-(id)init{
    
    self=[super init];
    
    localUserData = [NSUserDefaults standardUserDefaults];
    // 通知更新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadLeftMenu) name:@"reloadLeftMenu" object:nil];
    
    
    
    
    //設定一個值取得螢幕本身的寬與高
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    //設定準備讀取存取在 UserDefaults 的資料
    defaults = [NSUserDefaults standardUserDefaults];

    //設定手指觸控事件加入到 View 上
    putWayLeftMenu= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
    [self addGestureRecognizer:putWayLeftMenu];
    //設定當通知發生時，執行 hidden func 來隱藏 SliderMenuViewLeft
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hidden) name:@"hiddenLeftMenu" object:nil];
    //設定當通知發生時，執行 putAwayLeftMenu 來收起 SliderMenuViewLeft
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(putAwayLeftMenu) name:@"putAWayLeftMenu" object:nil];
    //設定當通知發生時，執行 updateTableViewContrler 來更新資料
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableViewContrler) name:@"updateTableViewContrler" object:nil];

    //設定 View 本身的比例
    self.MenuScreenScale=0.5;
    //設定 View 本身的高與寬，還有屬性。
    self.frame=CGRectMake((-fullScreenBounds.size.width*self.MenuScreenScale),20,
                                fullScreenBounds.size.width*self.MenuScreenScale,fullScreenBounds.size.height);
    self.layer.borderColor = [UIColor flatBlackColor].CGColor;
    self.backgroundColor=[UIColor flatSkyBlueColor];
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    //self.layer.borderWidth = 1.0;
    self.layer.cornerRadius=25.0;
    //self.alpha = 0.8;
    //加入 TableView 到 View
    [self addTableMenu];
    
    
    //加入 Label 到 View
    UILabel * MyChildName=[UILabel new];
    MyChildName.text = MYCHILDNAME;
    MyChildName.frame=CGRectMake(10, 8, 100,100);
    MyChildName.textColor = [UIColor whiteColor];
    [self addSubview:MyChildName];
    //加入 Button 到 View
    UIButton *AddChild = [UIButton new];
    AddChild.frame=CGRectMake(140,38, 40, 40);
    [AddChild setTitle:@"添加" forState:UIControlStateNormal];
    [AddChild addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:AddChild];
    
    //設定準備下載網路上的資料，並設定更新動畫效果
//    UILabel *updatedescription =
//    [[UILabel alloc] initWithFrame:CGRectMake(65,35,
//    MenuTableView.frame.size.width, MenuTableView.frame.size.height)];
//    [updatedescription setText:@"更新中..."];
//    [updatedescription setTextColor:[UIColor flatSkyBlueColor]];
//    downloadChildBigSticker = [[UpdateDataView alloc] initWithFrame:CGRectMake(0, 0, MenuTableView.frame.size.width, MenuTableView.frame.size.height)];
//    [downloadChildBigSticker addSubview:updatedescription];
//    [MenuTableView addSubview:downloadChildBigSticker];
    

    
    return self;
}

#pragma mark - Prepare to hidden SliderMenuViewLeft 準備隱藏 SliderMenuViewLeft 的顯示

-(void)hidden {
    self.hidden = true;
}

#pragma mark - Prepare to set fingerTouch event 設定觸控事件來移動左側選單

// Set fingerTouch event. 設定手指觸發事件來移動清單.
-(void)detectPan:(UIPanGestureRecognizer*)recognizer {
   CGPoint translation =  [recognizer translationInView:self.superview];
    // Set ViewListPosition not move out settiing position. 設定左側清單被移動時不能超過設定的位置.
    if(self.frame.origin.x > 0) {
        self.frame=CGRectMake(0,20,fullScreenBounds.size.width*self.MenuScreenScale,fullScreenBounds.size.height-22);
        
    }else if(self.frame.origin.x+translation.x < 0){
       self.frame=CGRectMake(lastLocation.x+translation.x,20,
                             fullScreenBounds.size.width*self.MenuScreenScale,
                             fullScreenBounds.size.height-22);
    }
    // Set ViewListPosition if smaller or bigger the setting Value, carried out the animated.
    //設定左側選單觸發事件結束時，執行所設定的數值執行動畫.
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        if(self.frame.origin.x < -100 ) {
            
            [self putAwayLeftMenu];
            
        } else {
            [UIView beginAnimations:@"inMenu" context:nil];
            [UIView setAnimationDelegate:self];
            self.frame=CGRectMake(0,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
            [UIView commitAnimations];
        }
    }
    
}

#pragma mark - Prepare to nextpage use NSNotificationCenter 設定通知來呼叫方法來開啟 AddChildSettingViewController

-(IBAction)next:(id)sender {
    
    [self putAwayLeftMenu];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settingChild" object:nil];
}

#pragma mark - Call this func to hidden the SliderMenuViewLeftView 呼叫這個方法執行動畫將左側選單隱藏.

-(void)putAwayLeftMenu {
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDelegate:self];
    self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
    [UIView commitAnimations];
}

#pragma mark - Prepare the TableView to add SliderMenuViewLeftView 新增一個 TableView 到 View.

-(void)addTableMenu {
    // Set TableView.
    MenuTableView=[[UITableView alloc] init];
    MenuTableView.delegate=self;
    MenuTableView.dataSource=self;
    MenuTableView.allowsSelection=YES;
    MenuTableView.frame=CGRectMake(0,70, self.frame.size.width, self.frame.size.height-80);
    //To clean the tableView line Between. 去除 tableView cell 與 cell 之間的分隔線.
    //MenuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addSubview:MenuTableView];
    
}

#pragma mark - Call this func SliderMenuViewLeftView to select 設定這個方法來呼叫顯示 SliderMenuViewLeftView

-(void)callMenu{
    
    //解除 SliderMenuViewLeft 本身的隱藏
    self.hidden = false;
    //準備 SliderMenuViewLeft 的動畫
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDelegate:self];
    if (self.frame.origin.x==-fullScreenBounds.size.width*self.MenuScreenScale) {
        self.frame=CGRectMake(0,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
    } else{
        [self putAwayLeftMenu];
    }
    [UIView commitAnimations];

}

#pragma mark - Prepare Update SetInfoTableViewControler 準備更新 SetInfoTableViewControler

-(void)updateTableViewContrler {
    
    //準備讀取存取的孩子姓名陣列
    readChildTextFieldnameArray = [defaults objectForKey:@"ChildName"];
    NSLog(@"  childnames: %@", readChildTextFieldnameArray);
    //準備讀取存取的孩子生日陣列
    readChildBirthdayFieldArray = [defaults objectForKey:@"ChildBirthday"];
    NSLog(@"  childnames: %@", readChildBirthdayFieldArray);
        readChildBigStickerArray = [[UseDownloadDataClass object] ReadChildBigStickerArray];
        NSLog(@"已經更新 左邊 TableView 了: %@",readChildBigStickerArray);
//    dispatch_async(dispatch_get_main_queue(), ^{
        [MenuTableView reloadData];
//    });
}



-(void) reloadLeftMenu {

    childNames = [localUserData objectForKey:@"childNames"];
    childBirthdays = [localUserData objectForKey:@"childBirthdays"];
    childPics = [localUserData objectForKey:@"childPics"];
    childIDs = [localUserData objectForKey:@"childIDs"];
    
    [MenuTableView reloadData];
    NSLog(@" 左側選單重載.... ");
}
#pragma mark - Set TableView Section and Row 設定 TableView 的 Section 和 Row

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return readChildTextFieldnameArray.count;
    return childNames.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SliderMenuLeftTableViewCell *myCell=[[SliderMenuLeftTableViewCell alloc]
                                         initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Menu"];
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
//        myCell.textLabel.text=[readChildTextFieldnameArray objectAtIndex:indexPath.section];
//        myCell.detailTextLabel.text =
//        [NSString stringWithFormat:@"生日:%@",[readChildBirthdayFieldArray objectAtIndex:indexPath.section]];
//        
//        if(readChildBigStickerArray.count != 0 ) {
//            NSData *readMyBigStickerData = [readChildBigStickerArray objectAtIndex:indexPath.section];
//            UIImage*BigStickerImage = [UIImage imageWithData:readMyBigStickerData];
//            NSLog(@"在Row裡面的圖片為 ：%@",BigStickerImage);
//            myCell.imageView.image = BigStickerImage;
//            NSLog(@"下載的圖片解碼為： %@",readChildBigStickerArray);
//        }
        
        myCell.textLabel.text = [childNames objectAtIndex:indexPath.section];
        myCell.detailTextLabel.text = [NSString stringWithFormat:@"生日:%@",[childBirthdays objectAtIndex:indexPath.section]];
        NSString *babyPicfilePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"userPic"] stringByAppendingPathComponent:[childPics objectAtIndex:indexPath.section]];
        NSURL *babyPicFileURL = [NSURL fileURLWithPath:babyPicfilePath];
        
        NSData *babyPicData = [NSData dataWithContentsOfURL:babyPicFileURL];
        UIImage *babyPicImage = [UIImage imageWithData:babyPicData];
        
        myCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        myCell.imageView.image = babyPicImage;
        
        
        //12343
    });
    
    return myCell;

    
  }

#pragma mark - Prepare when tableViewdidSelectRowAtIndexPath 設定選擇 TableView 的選項時，執行方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //為table Cell 加上選取後的動畫。
    
    NSInteger ChildID = indexPath.section;
    [localUserData setInteger:ChildID forKey:@"currentBabyIndex"];
    //[defaults synchronize];
    
    
    
    // jerry 點擊左側選單修改預設寶貝資料
    NSInteger babyid = [[[localUserData objectForKey:@"childIDs"] objectAtIndex:indexPath.section] integerValue];
    NSString *babyName = [[localUserData objectForKey:@"childNames"] objectAtIndex:indexPath.section];
    NSString *babyBirth = [[localUserData objectForKey:@"childBirthdays"] objectAtIndex:indexPath.section];
    NSString *babyID = [NSString stringWithFormat:@"%ld", babyid];
    NSString *babyPic = [[localUserData objectForKey:@"childPics"] objectAtIndex:indexPath.section];
    
    //日期
    NSString *dateString = babyBirth;
    //將取回的日期轉成NSDate
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [gmtDateFormatter dateFromString:dateString];
    
    
    [localUserData setObject:babyID forKey:@"babyid"];
    [localUserData setObject:babyName forKey:@"currentBabyName"];
    [localUserData setObject:date forKey:@"currentBabyBirthday"];
    [localUserData setObject:babyPic forKey:@"currentBabyPic"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"reloadBabyPicNamePost" object:nil];
    
    //--
    
    
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDelegate:self];
    self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
    [UIView commitAnimations];

}

#pragma mark - Prepare to set tableHightForRow 設定 TableView 中的 Cell 的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Prepare the TableView Of Section title 設定 TableView 中的 Section 的文字與高度

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @" ";
}



@end
