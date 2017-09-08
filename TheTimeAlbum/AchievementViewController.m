//
//  AchievementViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/30.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <ChameleonFramework/Chameleon.h>
#import "AchievementViewController.h"
#import "HeadView.h"
#import "myDefines.h"
#import "MyCommunicator.h"
#import "achievementItem.h"
#import "AchievementTableViewCell.h"

@interface AchievementViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSUserDefaults *localUserData;
    MyCommunicator *comm;
    
    NSMutableArray *incomingAchievements;             //暫存下載回來的成就
    NSMutableArray *getAchievementItems;       //存成就物件的陣列
    NSMutableArray *savedAchievementItems;     //從userdefault讀出的成就物件陣列
    NSInteger lastAchievementID;
    
    //準備讀取目前當下所選取的孩子ID
    NSInteger ChildID;
    //準備放置讀取儲存的孩子大頭貼圖片
    UIImage *ChildStickerImage;
    //準備放置讀取儲存的孩子背景圖片
    UIImage *MyChildBackgroundImage;
    //準備讀取所選取的孩子ID來讀取孩子名字陣列
    NSArray *readChildTextFieldnameArray;
    
    
    NSArray *readMyChildBackImageArray;
}

@property (weak, nonatomic) UITableView *myTableView;
@property (weak, nonatomic) HeadView * myView;

@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, assign) BOOL statusBarStyleControl;
@end

@implementation AchievementViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatBlueColor];
    
    
    
    // 新增完成就接收廣播
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doReloadJob)
                                                 name:@"NewAchievementAdded"
                                               object:nil];
    
    // communicator
    comm = [MyCommunicator sharedInstance];
    // user default
    localUserData = [NSUserDefaults standardUserDefaults];
    
    // 半透明navgation bar
    _statusBarStyleControl = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //準備讀取所選取的孩子ID來讀取孩子大頭貼陣列
    //準備讀取儲存的孩子大頭貼陣列
    NSArray *readChildBigStickerArray = [localUserData objectForKey:@"MyBigSticker"];
    ChildID = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChildID"];
    NSData* ChildBigStickerImageData = [readChildBigStickerArray objectAtIndex:ChildID];
    if(ChildBigStickerImageData){
        ChildStickerImage = [UIImage imageWithData:ChildBigStickerImageData];
        NSLog(@"照片為： %@",ChildStickerImage);
    }
    //讀取孩子背景圖片陣列
    readMyChildBackImageArray = [localUserData objectForKey:@"readMyChildBackImageArray"];
    
    //Prepare the readChildTextFieldnameArray. 準備讀取所創建的孩子名字，根據所選取的孩子ID來決定孩子的名字。
    readChildTextFieldnameArray = [localUserData objectForKey:@"ChildName"];
    
    
    
    
    [self initUI];
    lastAchievementID = 1;
    incomingAchievements = [NSMutableArray new];
    getAchievementItems = [NSMutableArray new];
    savedAchievementItems = [NSMutableArray new];
    [self doReloadJob];
    
}
- (void)initUI {
    
    UITableView * myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navHeight, VCWidth, VCHeight - navHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.contentInset = UIEdgeInsetsMake(headRect.size.height-navHeight-navHeight + 12, 0, 45, 0);
    _myTableView = myTableView;
    
    //myTableView.backgroundColor = [UIColor redColor];
    // 註冊nib
    self.myTableView.rowHeight = 160;
    //self.myTableView.tableHeaderView.hei
    [myTableView registerNib:[UINib nibWithNibName:@"AchievementTableViewCell" bundle:nil] forCellReuseIdentifier:@"achievementCell"];

    
    [self.view addSubview:myTableView];
    
//    HeadView * vc = [[HeadView alloc]initWithFrame:headRect backgroundView:@"Fox.jpg" headView:@"head.png" headViewWidth:(CGFloat)(VCWidth / 4) signLabel:@"紀錄寶寶成長的每個重要時刻"];
    
    HeadView * vc = [[HeadView alloc]initWithFrameByBryan:headRect backgroundView:readMyChildBackImageArray[ChildID]
                                                 headView:ChildStickerImage
                                            headViewWidth:(CGFloat)(VCWidth / 4) signLabel:readChildTextFieldnameArray[ChildID]];
    
    _myView = vc;
    _myView.backgroundColor = [UIColor clearColor];
    _myView.userInteractionEnabled = NO;
    [self.view addSubview:vc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return getAchievementItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    achievementItem * tempitem = [getAchievementItems objectAtIndex:indexPath.item];
    //init xib
    AchievementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"achievementCell" forIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    
    //NSLog(@" count :%lu" , (unsigned long)getAchievementItems.count);
    if (getAchievementItems.count == 0) {

        //
        cell.titleText.text = [NSString stringWithFormat:@"cell---%ld",indexPath.row + 1];
        return cell;
        
    } else {
        
        NSString *thisTitle = tempitem.achievementTitle;
        NSString *thisHowManyDays = [NSString stringWithFormat:@"第: %lu 天", getAchievementItems.count-indexPath.item ];
        NSString *thisCreateDate = tempitem.achievementCreatDate;
        
        cell.titleText.text = thisTitle;
        cell.howManyDays.text = thisHowManyDays;
        NSLog(@"the date: %@", thisCreateDate);
        cell.creatDate.text = thisCreateDate;
        cell.achievementPic.image = [UIImage imageNamed:@"cup01.jpg"];
        return cell;
    }
    
    

    return nil;
}
- (IBAction)reload:(id)sender {
    [self doReloadJob];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset_Y = scrollView.contentOffset.y + headRect.size.height+12;
    if  (offset_Y < 0) {
        
        _myView.backgroundView.contentMode = UIViewContentModeScaleToFill;
        
        _myView.backgroundView.frame = CGRectMake(offset_Y*0.5 , -navHeight, VCWidth - offset_Y, headRect.size.height - offset_Y);
        
        _myView.maskView.frame = CGRectMake(offset_Y*0.5 , -navHeight, VCWidth - offset_Y, headRect.size.height - offset_Y);
    }else if (offset_Y > 0 && offset_Y <= (headRect.size.height-navHeight-navHeight)) {
        
        _myView.backgroundView.contentMode = UIViewContentModeBottom;
        CGFloat y = navHeight* offset_Y/(headRect.size.height-navHeight-navHeight)-navHeight;
        
        _myView.backgroundView.frame = CGRectMake(0 ,y , VCWidth , headRect.size.height -(navHeight + y) - offset_Y);
        
        CGFloat width = offset_Y*(40-(VCWidth / 4))/(headRect.size.height-navHeight-navHeight)+(VCWidth / 4);
        _myView.headView.frame =CGRectMake(0, 0, width,width);
        _myView.headView.layer.cornerRadius =width*0.5;
        _myView.headView.center = _myView.backgroundView.center;
        
        _myView.signLabel.frame =CGRectMake(0, CGRectGetMaxY(_myView.headView.frame), VCWidth, 40);
        
        _myView.signLabel.alpha = 1 - (offset_Y*3 / (headRect.size.height-navHeight-navHeight) /2);
        _myView.headView.alpha = 1 - (offset_Y*3 / (headRect.size.height-navHeight-navHeight) /2);
        
        _myView.maskView.frame = CGRectMake(0 ,y , VCWidth , headRect.size.height -(navHeight + y) - offset_Y);
        
    }else if(offset_Y > (headRect.size.height-navHeight-navHeight)) {
        _myView.backgroundView.contentMode = UIViewContentModeTop;
        
        CGFloat y = navHeight* (headRect.size.height-navHeight-navHeight)/(headRect.size.height-navHeight-navHeight)-navHeight;
        
        _myView.backgroundView.frame = CGRectMake(0 ,y , VCWidth , headRect.size.height -(navHeight + y) - (headRect.size.height-navHeight-navHeight));
        
        
        CGFloat width = (headRect.size.height-navHeight-navHeight)*(40-(VCWidth / 4))/(headRect.size.height-navHeight-navHeight)+(VCWidth / 4);
        _myView.headView.frame =CGRectMake(0, 0, width,width);
        _myView.headView.layer.cornerRadius =width*0.5;
        _myView.headView.center = _myView.backgroundView.center;
        
        _myView.signLabel.frame =CGRectMake(0, CGRectGetMaxY(_myView.headView.frame), VCWidth, 40);
        
        _myView.signLabel.alpha = 1 - ((headRect.size.height-navHeight-navHeight)*3 / (headRect.size.height-navHeight-navHeight) /2);
        _myView.headView.alpha = 1 - ((headRect.size.height-navHeight-navHeight)*3 / (headRect.size.height-navHeight-navHeight) /2);
        
        _myView.maskView.frame = CGRectMake(0 ,y , VCWidth , headRect.size.height -(navHeight + y) - (headRect.size.height-navHeight-navHeight));
        
    }
    CGFloat offsetYofheader = headRect.size.height-navHeight-navHeight - 64;
    NSLog(@"off: %f", offsetYofheader);
    NSLog(@"offsetY : %f", offset_Y);
    // 控制navigation bar
    if (offset_Y > offsetYofheader && offset_Y <= offsetYofheader *3) {
        
        _statusBarStyleControl = YES;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItems.firstObject.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItems.lastObject.tintColor = [UIColor blackColor];
        
        _alphaMemory = offset_Y/(offsetYofheader * 3) >= 1 ? 1 : offset_Y/(offsetYofheader * 3);
        
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
        
    }
    else if (offset_Y <= offsetYofheader*3) {
        
        _statusBarStyleControl = NO;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItems.firstObject.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItems.lastObject.tintColor = [UIColor whiteColor];
        
        _alphaMemory = 0;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    }
    else if (offset_Y > offsetYofheader*3) {
        _alphaMemory = 1;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
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

#pragma mark - reload and handle message  下載處理資料
#pragma mark - doReloadJob     網路接收 處理資料
// 從網路載入貼文內容
- (void) doReloadJob {
    NSLog(@"1afjkj;lfj=======");
    
    
    NSString *babyID = [localUserData objectForKey:@"babyid"];
    [comm retriveAchievementsByBabyID:babyID
                           completion:^(NSError *error, id result) {
        // AFN 連線是否成功
        if(error){
            NSLog(@"** retriveAchievementsByBabyID Fail: %@", error);
            [self doReloadJob];
            return;
        }
        // 伺服器php指令是否成功
        if([result[RESULT_KEY] boolValue] == false){
            NSLog(@"** retriveAchievementsByBabyID Fail: %@", result[ERROR_CODE_KEY]);
            [self doReloadJob];
            return;
        }
                               //取回來的 成就們的 陣列
        NSArray *items = result[ACHIEVEMENTS_KEY];
        NSLog(@"Receive achievements: %lu", items.count);
        
        // Return if there is no new message.
        if(items.count == 0){
            NSLog(@"No new achievement, do nothing and return.");
            return;
        }
        [getAchievementItems removeAllObjects];
                               
                               
        // Keep and update latest lastMessageID
        NSDictionary *lastItem = items.lastObject;
        lastAchievementID = [lastItem[LAST_ACHIEVEMENT_ID_KEY] integerValue];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:lastAchievementID forKey:LAST_ACHIEVEMENT_ID_KEY];
        [defaults synchronize];
        
        
        // Handle new messages
        [incomingAchievements addObjectsFromArray:items];
        NSLog(@"** do before handle messages of achievements");
        [self handleIncomingMessages];
        NSLog(@"** done with handle messages of achievements");
                               
                               NSLog(@" %lu, %lu, ", (unsigned long)incomingAchievements.count, (unsigned long)getAchievementItems.count);
                               
    }];
    
    
}

//處理暫存區array的功能
//----------------------------------------------------------------------------------
-(void) handleIncomingMessages{
    //Exit when there is no more message need to be handled.
    if(incomingAchievements.count == 0){
        //[self doUnlock];
        [self.myTableView reloadData];
        NSLog(@"-- reload tableview");
        return;
    }
    
    NSDictionary *tmp = incomingAchievements.firstObject;
    [incomingAchievements removeObjectAtIndex:0];
    
    //Save tmp into logManager.
    //[logManager addChatLog:tmp];
    
    
    // Parse all fields of each message.
    //將NSDictionary中的NSNumber 轉成 NSInteger
    NSInteger achievementID = [tmp[@"id"] integerValue];
    NSInteger ofBabyID = [tmp[@"ofBabyId"] integerValue];
    NSString *title = tmp[@"title"];
    NSString *picName = tmp[@"picName"];
    NSString *creatDate = tmp[@"creatDate"];
    //NSDate  *date = [NSDate dateWithTimeIntervalSince1970:tmp[@"creattime"]];
    
    NSLog(@"---got achievement item: %ld, %ld, %@, %@, %@", (long)achievementID, (long)ofBabyID, title, picName, creatDate);
    
    //NSString *displayMessage = [NSString stringWithFormat:@"%@", message];
    
    // Prepare each achievement item
    achievementItem *item = [achievementItem new];
    
    item.achievementId = achievementID;
    item.achievementTitle = title;
    item.achievementPicName = picName;
    item.achievementCreatDate = creatDate;
    
    
    
    
    [getAchievementItems addObject:item];

    
    [self handleIncomingMessages];

}
//----------------------------------------------------------------------------------

@end
