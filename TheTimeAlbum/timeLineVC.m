//
//  timeLineVC.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/23.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "timeLineVC.h"
#import "HeadView.h"
#import <UIKit/UIKit.h>
#import "myDefines.h"
#import "MyCollectionViewCellWithText.h"
#import "MyCollectionViewCellWithImage1.h"
#import "textLayout.h"
#import <BFPaperButton.h>
#import <AFNetworking.h>
#import "addNewMessageVC.h"
#import <Chameleon.h>
#import "MyAccountData.h"
#import "MyCommunicator.h"
#import "AddChildSettingViewController.h"
#import "PostItem.h"
#import "EditTextPostViewController.h"

@interface timeLineVC ()<UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITapGestureRecognizer *putWayMenu;     // 觸控事件 : 任意點擊縮回側邊選單
    
    MyAccountData *currentuser;
    NSUserDefaults *localUserData;
    MyCommunicator *comm;
    
    NSMutableArray *incomingPosts;   //暫存訊息以處理的陣列
    NSMutableArray *postItems;
    NSData *saveData;
    NSInteger lastPostID;
    //BOOL isSuccess;
    
    
    // Boen
    //準備讀取目前當下所選取的孩子ID
    NSInteger ChildID;
    //準備讀取儲存的孩子大頭貼陣列
    NSArray *readChildBigStickerArray;
    //準備放置讀取儲存的孩子大頭貼圖片
    UIImage *ChildStickerImage;
    //準備放置讀取儲存的孩子背景圖片
    UIImage *MyChildBackgroundImage;
    //準備讀取所選取的孩子ID來讀取孩子名字陣列
    NSArray *readChildTextFieldnameArray;
    //-- Boen
    
}
-(NSMutableArray*) myStaticArray;
@property (weak, nonatomic) UITableView *myTableView;
@property (weak, nonatomic) UICollectionView *myCollectionView;
@property (weak, nonatomic) HeadView * myView;

// 半透明navgation bar
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, assign) BOOL statusBarStyleControl;
//--

@end

@implementation timeLineVC

-(NSMutableArray*) myStaticArray
{
    static NSMutableArray* theArray = nil;
    if (theArray == nil)
    {
        theArray = [[NSMutableArray alloc] init];
    }
    return theArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加入觸控事件 : 任意點擊縮回側邊選單
    putWayMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(putWayMenu)];
    [self.view addGestureRecognizer:putWayMenu];
    //--
    
    //isSuccess = false;
    
    // communicator
    comm = [MyCommunicator sharedInstance];
    
    // 半透明navgation bar
    _statusBarStyleControl = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //--
    // 初始化collection view
    [self initCollectionView];
    
    // 初始化標頭view
    [self initHeadView];
    
    //初始化浮動按鈕
    [self initBtn];
    
    
    // navi drawer
    [self SettingSilderMenuViewAndButtonItemToNavigationBar];
    // Prepare the NorificationCenter change ViewConroller to AddChildSettingViewController.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewContrllerToAddChildSettingViewController) name:@"settingChild" object:nil];
    //--
    
    
    
    // About user data.         用戶資料存取
    localUserData = [NSUserDefaults standardUserDefaults];
    currentuser = [MyAccountData sharedCurrentUserData];
    NSLog(@"_____id: %@, mail: %@, gender: %@, name: %@", currentuser.userId, currentuser.userMail, currentuser.gender, currentuser.userName);
    //--
    
// FIXME: getbabydata  假資料
    // get baby data from server
   // localUserData setObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
    if([localUserData objectForKey:@"babyid"] == nil){
        [self getBabyData];
    }
    // 假資料
    [localUserData setObject:@"1" forKey:@"babyid"];
    [localUserData setObject:@"王大明" forKey:@"babyname"];
    [localUserData setObject:@"2017-07-23 00:00:00" forKey:@"babybirthday"];

    
    // 載入貼文
    lastPostID = 1;
    incomingPosts = [NSMutableArray new];
    postItems = [NSMutableArray new];
    
    //改在viewwill appear
    //[self doReloadJob];
    
    
    
    // Boen
    //準備讀取所選取的孩子ID來讀取孩子大頭貼陣列
    readChildBigStickerArray = [localUserData objectForKey:@"MyBigSticker"];
    ChildID = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChildID"];
    NSData* ChildBigStickerImageData = [readChildBigStickerArray objectAtIndex:ChildID];
    if(ChildBigStickerImageData){
        ChildStickerImage = [UIImage imageWithData:ChildBigStickerImageData];
        NSLog(@"照片為： %@",ChildStickerImage);
    }
    //讀取孩子背景圖片陣列
    NSArray *readMyChildBackImageArray = [localUserData objectForKey:@"readMyChildBackImageArray"];
    NSData *readMyChildBackImageData = [readMyChildBackImageArray objectAtIndex:ChildID];
    if(readMyChildBackImageData) {
        MyChildBackgroundImage  = [UIImage imageWithData:readMyChildBackImageData];
    }
    // Prepare the readChildTextFieldnameArray. 準備讀取所創建的孩子名字，根據所選取的孩子ID來決定孩子的名字。
    readChildTextFieldnameArray = [localUserData objectForKey:@"ChildName"];
    //-- Boen
    
}

#pragma mark - 初始化ＵＩ相關物件
//
- (void) initCollectionView {
    // Collection view's layout about text message.     collectionview中文字訊息的layout
    textLayout *myTextLayout = [[textLayout alloc] init];
    
    UICollectionView * myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navHeight-NAV_BAR_HEIGHT, VCWidth, VCHeight) collectionViewLayout:myTextLayout];
    
    // collection view setting
    myCollectionView.backgroundColor = [UIColor flatWhiteColor];
    
    [myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCellWithText" bundle:nil]  forCellWithReuseIdentifier:@"message"];
    [myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCellWithImage1" bundle:nil]  forCellWithReuseIdentifier:@"onePicCell"];
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.contentInset = UIEdgeInsetsMake(headRect.size.height-navHeight-navHeight, 0, 0, 0);
    _myCollectionView = myCollectionView;
    [self.view addSubview:myCollectionView];
    
    
    // refresh control      重新整理的套件
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(doReloadJob) forControlEvents:UIControlEventValueChanged];
//    [self.myCollectionView addSubview:refreshControl];
}

// Initial HeadView      初始化標頭view元件
- (void) initHeadView {
    
    
    HeadView * vc = [[HeadView alloc]initWithFrame:headRect backgroundView:@"Fox.jpg"
                                          headView:@"head.png"
                                     headViewWidth:(CGFloat)(VCWidth / 4) signLabel:@"王小明"];
    
//    HeadView * vc = [[HeadView alloc]initWithFrameByBryan:headRect backgroundView:MyChildBackgroundImage
//                                          headView:ChildStickerImage
//                                     headViewWidth:(CGFloat)(VCWidth / 4) signLabel:readChildTextFieldnameArray[ChildID]];
    
    _myView = vc;
    _myView.backgroundColor = [UIColor clearColor];
    _myView.userInteractionEnabled = NO;
    [self.view addSubview:vc];
    
}
//--

// 浮動按鈕
- (void)initBtn{
    BFPaperButton *circle2 = [[BFPaperButton alloc] initWithFrame:CGRectMake(VCWidth-70, VCHeight-130, 50, 50) raised:YES];
    [circle2 setTitle:@"＋" forState:UIControlStateNormal];
    [circle2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [circle2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [circle2 addTarget:self action:@selector(btnAddNewPostPressed) forControlEvents:UIControlEventTouchUpInside];
    circle2.backgroundColor = [UIColor colorWithRed:0.3 green:0 blue:1 alpha:1];
    circle2.tapCircleColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.6];  // Setting this color overrides "Smart Color".
    circle2.cornerRadius = circle2.frame.size.width / 2;
    circle2.rippleFromTapLocation = NO;
    circle2.rippleBeyondBounds = YES;
    circle2.tapCircleDiameter = MAX(circle2.frame.size.width, circle2.frame.size.height) * 1.3;
    [self.view addSubview:circle2];

}

- (void) btnAddNewPostPressed {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"addNewMessage" bundle:[NSBundle mainBundle]];
    addNewMessageVC *addNewMessageController = [storyboard instantiateViewControllerWithIdentifier:@"addNewMessageVC"];
    [self.navigationController pushViewController:addNewMessageController animated:YES];
}


#pragma mark - default implements method    基本繼承方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    
    // Boen
    //讀取是否已有建立第一個孩子.
    NSUserDefaults *readChildNameDefaults;
    readChildNameDefaults = [NSUserDefaults standardUserDefaults];
    //如果讀出的陣列數量為零的話，就執行 AddChildSettingViewController 來創造第一個孩子。
    NSArray *readChildTextFieldnameArray = [readChildNameDefaults objectForKey:@"ChildName"];
    if(readChildTextFieldnameArray.count == 0) {
        AddChildSettingViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"AddChildSettingViewController"];
        [self presentViewController:nextPage animated:YES completion:nil];
    }
    //-- Boen

    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [self doReloadJob];
    [super viewWillAppear:animated];
    _alphaMemory = 0;
    //毛玻璃
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
    //    [self.navigationItem.leftBarButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    if (_alphaMemory == 0) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    //--
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
    
    // 毛毛temp
    if (self.alphaBlock) {
        self.alphaBlock(_alphaMemory);
    }
    
    if (_alphaMemory < 1) {
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
        [UIView animateWithDuration:0.15 animations:^{
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        }];
    }
    //--
}

#pragma mark: collectionview delegate       collectionview 相關
// collection implement methods
//------------------------------------------------------------------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return postItems.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *onePicID = @"onePicCell";
    //static NSString *twoPicID = @"twoPicCell";
    //static NSString *threePicID = @"threePicCell";
    //static NSString *mailID = @"mailCell";
    //static NSString *textMessageID = @"texMessageCell";
    
    MyCollectionViewCellWithText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"message" forIndexPath:indexPath];
    
    //MyCollectionViewCellWithImage1 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"onePicCell" forIndexPath:indexPath];
    
    //cell.image = self.images[indexPath.item%(self.images.count)];
    //
    if(postItems.count == 0) {
        cell.titleText.text = [NSString stringWithFormat:@"%ld",indexPath.item ];
        cell.detalText.text = [NSString stringWithFormat:@"12134567890-09876543245678909876543234567 %ld", indexPath.item];
    } else {
        PostItem *pp =[postItems objectAtIndex:indexPath.item];
        cell.titleText.text = [NSString stringWithFormat:@"第 %ld 天",postItems.count -indexPath.item ];
        cell.detalText.text = pp.content;
    }
    
    return cell;
}
//--

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
// FIXME: get saved postItems..
    // get data
    //NSData *getDataFromUserdefaults = [localUserData objectForKey:@"postItems"];
    //NSArray *getSavedData = [NSKeyedUnarchiver unarchiveObjectWithData:getDataFromUserdefaults];
    //NSLog(@"array = %@", getSavedData);
    PostItem *tempItem = [self.myStaticArray objectAtIndex:indexPath.item];
    NSLog(@"-- get item at %@ , %ld, %@", tempItem.content, tempItem.postID, tempItem.postDateString);
    
    
    
    NSLog(@" == On row  %ld selected...", indexPath.item);
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"EditTextPost" bundle:[NSBundle mainBundle]];
    EditTextPostViewController *editController = [storyboard instantiateViewControllerWithIdentifier:@"EditTextPostVC"];
    
// FIXME: 傳到下一頁的資料
    editController.titleString = tempItem.postDateString;
    editController.contentString = tempItem.content;
    editController.postID = tempItem.postID;
    
    
    //collectionView dis
    [self.navigationController pushViewController:editController animated:YES];
    
    
}
- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


#pragma mark - doReloadJob    網路接收 處理資料
// 從網路載入貼文內容
- (void) doReloadJob {
    NSLog(@"1afjkj;lfj=======");
    
    
    [comm retrivePostsWithLastPostID:@"1"
                              babyid:@"1"
                                completion:^(NSError *error, id result) {
                                    // AFN 連線是否成功
                                    if(error){
                                        NSLog(@"retriveMessagesWithLastMessageID Fail: %@", error);
                                        [self doReloadJob];
                                        return;
                                    }
                                    // 伺服器php指令是否成功
                                    if([result[RESULT_KEY] boolValue] == false){
                                        NSLog(@"retriveMessagesWithLastMessageID Fail: %@", result[ERROR_CODE_KEY]);
                                        [self doReloadJob];
                                        return;
                                    }
                                    NSArray *items = result[POSTS_KEY];
                                    NSLog(@"Receive messages: %lu", items.count);
                                    
                                    // Return if there is no new message.
                                    if(items.count == 0){
                                        NSLog(@"No new message, do nothing and return.");
                                        return;
                                    }
                                    //FIXME: static array 可能會有問題
                                    [self.myStaticArray removeAllObjects];
                                    [postItems removeAllObjects];
                                    
                                    // Keep and update latest lastMessageID
                                    NSDictionary *lastItem = items.lastObject;
                                    lastPostID = [lastItem[POST_ID_KEY] integerValue];
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setInteger:lastPostID forKey:LAST_POST_ID_KEY];
                                    [defaults synchronize];
                                    
                                    
                                    // Handle new messages
                                    [incomingPosts addObjectsFromArray:items];
                                    NSLog(@"do before handle messager");
                                    [self handleIncomingMessages];
                                    NSLog(@"afjkj;lfj=======");
                                }];
    
}

//處理暫存區array的功能
//----------------------------------------------------------------------------------
-(void) handleIncomingMessages{
    //Exit when there is no more message need to be handled.
    if(incomingPosts.count == 0){
        //[self doUnlock];
        
// FIXME: save postItems to somewhere...
        // 存檔
        //saveData = [NSKeyedArchiver archivedDataWithRootObject:postItems];
        //[localUserData setObject:saveData forKey:@"postItems"];
        
        [self.myCollectionView reloadData];
        return;
    }
    
    NSDictionary *tmp = incomingPosts.firstObject;
    [incomingPosts removeObjectAtIndex:0];
    
    //Save tmp into logManager.
    //[logManager addChatLog:tmp];
    
    
    // Parse all fields of each message.
    //將NSDictionary中的NSNumber 轉成 NSInteger
    NSInteger postID = [tmp[POST_ID_KEY] integerValue];
    NSInteger postType = [tmp[TYPE_KEY] integerValue];
    NSInteger sender = [tmp[SENDER_UID_KEY] integerValue];
    NSString *message = tmp[POST_KEY];
    
  
    //
    //FIXME:  存取 mysql過來的時間格式 成為 nsdate (準備將娶回來的createtime和寶寶生日相減)
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *dateString = tmp[@"creattime"];
    NSDate  *date = [gmtDateFormatter dateFromString:dateString];
    NSLog(@"-- date :%@", date);
    
    NSLog(@"----- %ld, %ld, %ld, %@, %@", (long)postID, (long)postType, (long)sender, message ,dateString);
    
    //NSString *displayMessage = [NSString stringWithFormat:@"%@: %@ (%ld)", sender, message, postID ];
    NSString *displayMessage = [NSString stringWithFormat:@"%@", message];
    // Prepare ChatItem
    
    
    
    
    //  Save PostItem
    PostItem *item = [PostItem new];
    item.content = displayMessage;
    item.postID = postID;
    item.postTypeInt = postType;
    item.postDateString = dateString;
    item.postDate = date;
    
    [postItems addObject:item];
    
    //FIXME: static array 可能會有問題
    [self.myStaticArray  addObject:item];
    
    //item.image =
    
    if(postType == 1){
        item.postType = PostTypeText;
    } else if(postType == 2) {
        item.postType = PostTypeOnePic;
    } else if(postType == 3) {
        item.postType = PostTypeTwoPic;
    } else if(postType == 4) {
        item.postType = PostTypeThreePic;
    }
    
    
    
    if(postType == 1){   //Text Message
        //[_chatView addChatItem:item]; //+
        
        // 如果post type 是文字
        [self handleIncomingMessages];
    } else {                //Photo Message
        // 如果是圖片
//        // Check if need to download photo or not
//        UIImage *cachedImage = [logManager loadImageWithName:message];
//        if(cachedImage != nil){
//            item.image = cachedImage;
//            [_chatView addChatItem:item];
//            [self handleIncomingMessages];
//            return;
//        }
//        // Download Image if necessary
//        [comm downloadPhotoWithFilename:message completion:^(NSError *error, id result) {
//            if(error==nil){
//                UIImage *image = [UIImage imageWithData:result];
//                item.image=image;
//                
//                // Save Photo to LogManager
//                [logManager saveImageWithName:message data:result];
//                
//            }
//            //[_chatView addChatItem:item];
//            [self handleIncomingMessages];
//        }];
    }
}
//----------------------------------------------------------------------------------
//FIXME: 尚未實作從SQL撈babydata 存入Userdefaults
- (void) getBabyData {
    NSString *localUID = [localUserData objectForKey:@"uid"];
    //NSLog(@"aaa uid : %@",localUID);
    //... [comm getBabyDataByBabyID:(NSString*)babyID ];

}




#pragma mark - didScroll   滾動畫面改變的功能
// Adjust headview and navigationbar by scrolling the view
// 捲動畫面時改變header大小及navbar透明度的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_Y = scrollView.contentOffset.y + headRect.size.height;
    if  (offset_Y < 0) {
        
        _myView.backgroundView.contentMode = UIViewContentModeScaleToFill;
        
        _myView.backgroundView.frame = CGRectMake(offset_Y*0.5 , -navHeight, VCWidth - offset_Y, headRect.size.height - offset_Y);
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

// 收起左側 or 右側 選單
-(void)putWayMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"putAWayLeftMenu" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"putAwayRightMenu" object:nil];
}
//------------------------------------------------------------------

// 暫時
- (IBAction)reload:(id)sender {
    [self doReloadJob];
    //[self initHeadView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- navigation drawer method    側邊選單的東西
-(void)handlePan:(id)sender{
    [self.MenuLeft callMenu];
}
//呼叫左側目錄選單出現
-(void)callMenuLeft{
    [self.MenuLeft callMenu];
}
//呼叫右側目錄選單出現
-(void)callMenuRight{
    [self.MenuRight callMenu];
}

-(void)changeViewContrllerToAddChildSettingViewController {
    AddChildSettingViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"AddChildSettingViewController"];
    [self presentViewController:nextPage animated:YES completion:nil];
}

-(void)SettingSilderMenuViewAndButtonItemToNavigationBar {
    
    // Prepare the SliderMenuView add to WindowView.
    self.MenuLeft=[[SliderMenuViewLeft alloc] init];
    [[UIApplication sharedApplication].delegate.window addSubview:self.MenuLeft];
    
    self.MenuRight=[[SliderMenuViewRight alloc] init];
    [[UIApplication sharedApplication].delegate.window addSubview:self.MenuRight];
    
    // Prepare the Button add to NavigationBar.
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                  UIBarButtonSystemItemSearch target:self action:@selector(callMenuRight)];
    searchButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *messageButton = [UIBarButtonItem new];
    [messageButton setImage:[UIImage imageNamed:@"icon_message48x48.png"]];
    messageButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:searchButton,messageButton, nil];
    
    UIBarButtonItem *listButton = [UIBarButtonItem new];
    [listButton setAction:@selector(callMenuLeft)];
    [listButton setTarget:self];
    [listButton setImage:[UIImage imageNamed:@"清單30x30@2x.png"]];
    listButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = listButton;
    
}
//--



@end
