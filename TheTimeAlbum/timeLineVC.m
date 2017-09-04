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
#import "WriteMailViewController.h"
#import "MyCollectionViewCellWithText.h"
#import "MyCollectionViewCellWithImage1.h"
#import "MyCollectionViewCellWithImage3.h"
#import "MyCollectionViewCellUploading.h"
#import "ImageViewController.h"
#import "ImagePageViewController.h"
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
#import "UseDownloadDataClass.h"
#import "UpdateDataView.h"
#import "StartCreateFirstChildViewController.h"
#import <AWSS3.h>
#import <LGPlusButtonsView.h>
#import <TZImagePickerController.h>


@interface timeLineVC () <UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource, TZImagePickerControllerDelegate, LGPlusButtonsViewDelegate>
{
    UITapGestureRecognizer *putWayMenu;     // 觸控事件 : 任意點擊縮回側邊選單
    
    MyAccountData *currentuser;
    NSUserDefaults *localUserData;
    MyCommunicator *comm;
    
    NSMutableArray *incomingPosts;      //暫存訊息以處理的陣列
    NSMutableArray *postItems;
    NSData *saveData;
    NSInteger lastPostID;
    //BOOL isSuccess;
    
    NSInteger countingPos;              //判斷cell圖片要放在哪個位置的變數
    
    NSInteger uploadPhotosCount;        // 總共要上傳幾張
    NSInteger uploadedPhotosCount;        // 已完成上傳幾張
    NSMutableString *upFileNames;       //上傳圖片訊息的檔名
    int64_t totalBit;
    int64_t nowBit;
    
    // Boen
    //準備讀取目前當下所選取的孩子ID
    NSInteger ChildID;
    //準備讀取儲存的孩子大頭貼陣列
    NSArray *readChildBigStickerArray;
    //準備放置讀取儲存的孩子大頭貼圖片
    //UIImage *ChildStickerImage;

    //準備讀取所選取的孩子ID來讀取孩子名字陣列
    //NSArray *readChildTextFieldnameArray;
    
    //NSArray *readMyChildBackImageArray;
    
    //UIImage *MyChildBackGroundImage;
    
    HeadView * vc;
    NSArray *readChildTextFieldnameArray;
    //-- Boen
    
}
-(NSMutableArray*) myStaticArray;
@property (weak, nonatomic) UITableView *myTableView;
@property (weak, nonatomic) UICollectionView *myCollectionView;
@property (weak, nonatomic) HeadView * myView;

//上傳狀態
@property (weak, nonatomic) UIVisualEffectView * myEffectView;
@property (strong, nonatomic) UILabel *myStatusLabel;


@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;

// 存uploadrequest
@property (nonatomic, strong) NSMutableArray *collection;

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

- (void) onEffectViewTap {
    NSLog(@" tap tap");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    // 加入觸控事件 : 任意點擊縮回側邊選單
    putWayMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(putWayMenu)];
    putWayMenu.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:putWayMenu];
    //--
    
    // About user data.         用戶資料存取
    localUserData = [NSUserDefaults standardUserDefaults];
    currentuser = [MyAccountData sharedCurrentUserData];
    NSLog(@"_____id: %@, mail: %@, gender: %@, name: %@", currentuser.userId, currentuser.userMail, currentuser.gender, currentuser.userName);
    //--
    
    
    
    countingPos = 0;
    //isSuccess = false;
    self.collection = [NSMutableArray new];
    upFileNames = [NSMutableString new];
    totalBit = 0;
    nowBit = 0;
    
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
    
    // 初始化孩子大頭
    [self initChildrenPicBoen];
    
    
    // 初始化標頭view
    [self initHeadView];
    
    //初始化浮動按鈕
    //[self initBtn];
    [self initBtn2];
    
    // 初始化上傳狀態的view
    [self initBlurUploadingStatus];

    
    
    // navi drawer
    [self SettingSilderMenuViewAndButtonItemToNavigationBar];
    // Prepare the NorificationCenter change ViewConroller to AddChildSettingViewController.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewContrllerToAddChildSettingViewController) name:@"settingChild" object:nil];
    //--
    
    
    
   
    
// FIXME: getbabydata  假資料
    // get baby data from server
   // localUserData setObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
    if([localUserData objectForKey:@"babyid"] == nil){
        [self getBabyData];
    }
    //FIXME: 假資料
    [localUserData setObject:@"1" forKey:@"babyid"];
    [localUserData setObject:@"王大明" forKey:@"babyname"];
    [localUserData setObject:@"2017-07-23 00:00:00" forKey:@"babybirthday"];

    
    // 載入貼文
    lastPostID = 1;
    incomingPosts = [NSMutableArray new];
    postItems = [NSMutableArray new];
    
    //改在viewwill appear
    [self doReloadJob];
    
    //準備接收通知如果下載失敗通知重新下載資料
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(downloadDataFromServe) name:@"downloadDataFromServe" object:nil];
    
    
    //準備讀取所選取的孩子ID來讀取孩子大頭貼陣列
//    readChildBigStickerArray = [localUserData objectForKey:@"MyBigSticker"];
//    ChildID = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChildID"];
//    NSData* ChildBigStickerImageData = [readChildBigStickerArray objectAtIndex:ChildID];
//    if(ChildBigStickerImageData){
//        ChildStickerImage = [UIImage imageWithData:ChildBigStickerImageData];
//        NSLog(@"照片為： %@",ChildStickerImage);
//    }
//    //讀取孩子背景圖片陣列
//    readMyChildBackImageArray = [localUserData objectForKey:@"readMyChildBackImageArray"];
//    if(![readMyChildBackImageArray[ChildID] isKindOfClass:[NSString class]]) {
//        NSData *readMyChildBackImageData = [readMyChildBackImageArray objectAtIndex:ChildID];
//        MyChildBackGroundImage = [UIImage imageWithData:readMyChildBackImageData];
//    }
    // Prepare the readChildTextFieldnameArray. 準備讀取所創建的孩子名字，根據所選取的孩子ID來決定孩子的名字。
    //readChildTextFieldnameArray = [localUserData objectForKey:@"ChildName"];
    
    //FIXME: 可能還有問題的下載
    // 創建本地暫存資料夾
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"]
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
        NSLog(@"Creating 'download' directory failed. Error: [%@]", error);
    }
    
    
    
    
    
    
    
    
}



#pragma mark - 初始化ＵＩ相關物件
//
- (void) initCollectionView {
    // Collection view's layout about text message.     collectionview中文字訊息的layout
    textLayout *myTextLayout = [[textLayout alloc] init];
    
    UICollectionView * myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navHeight-NAV_BAR_HEIGHT, VCWidth, VCHeight) collectionViewLayout:myTextLayout];
    
    // collection view setting
    // 底色
    //NSArray *colors = @[[UIColor flatWhiteColor], [UIColor flatRedColor]];
    //myCollectionView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:(CGRect)myCollectionView.frame andColors: colors];
    myCollectionView.backgroundColor = [UIColor lightGrayColor];
    
    [myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCellWithText" bundle:nil]  forCellWithReuseIdentifier:@"MyCollectionViewCellWithText"];
    [myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCellWithImage1" bundle:nil]  forCellWithReuseIdentifier:@"onePicCell"];
    [myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCellWithImage3" bundle:nil]  forCellWithReuseIdentifier:@"MyCollectionViewCellWithImage3"];
    [myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCellUploading" bundle:nil]  forCellWithReuseIdentifier:@"MyCollectionViewCellUploading"];
    
    
    
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
    HeadView * vc;
    //if (MyChildBackgroundImage!= nil && ChildStickerImage !=nil) {
//        vc = [[HeadView alloc]initWithFrameByBryan:headRect backgroundView:MyChildBackgroundImage
//                                                 headView:ChildStickerImage
//                                            headViewWidth:(CGFloat)(VCWidth / 4) signLabel:readChildTextFieldnameArray[ChildID]];
    //} else {
    
       // vc = [[HeadView alloc]initWithFrame:headRect backgroundView:@"Fox.jpg"
       //                                       headView:@"head.png"
       //                                  headViewWidth:(CGFloat)(VCWidth / 4) signLabel:@"王小明"];
    
    //}
    
    
    
//    HeadView * vc = [[HeadView alloc]initWithFrame:headRect backgroundView:@"Fox.jpg"
//                                          headView:@"head.png"
//                                     headViewWidth:(CGFloat)(VCWidth / 4) signLabel:@"王小明"];
//    if(MyChildBackGroundImage) {
//        vc = [[HeadView alloc]initWithFrameByBryanImageBackground:headRect
//                                               backgroundView:MyChildBackGroundImage
//                                                     headView:ChildStickerImage
//                                                headViewWidth:(CGFloat)(VCWidth / 4) signLabel:readChildTextFieldnameArray[ChildID]];
//    }else {
//        vc = [[HeadView alloc]initWithFrameByBryan:headRect
//                                               backgroundView:readMyChildBackImageArray[ChildID]
//                                                     headView:ChildStickerImage
//                                                headViewWidth:(CGFloat)(VCWidth / 4) signLabel:readChildTextFieldnameArray[ChildID]];
//    }

//    HeadView * vc = [[HeadView alloc]initWithFrameByBryan:headRect backgroundView:MyChildBackgroundImage
//                                          headView:ChildStickerImage
//                                     headViewWidth:(CGFloat)(VCWidth / 4) signLabel:readChildTextFieldnameArray[ChildID]];
    
    _myView = vc;
    _myView.backgroundColor = [UIColor clearColor];
    _myView.userInteractionEnabled = NO;
    [self.view addSubview:vc];
    
}
//--
// 初始化孩子的圖片
- (void) initChildrenPicBoen {
    // Boen
    //準備讀取所選取的孩子ID來讀取孩子大頭貼陣列
//    NSLog(@" ??????? ???? ??");
//    readChildBigStickerArray = [localUserData objectForKey:@"MyBigSticker"];
//    ChildID = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChildID"];
//    NSData* ChildBigStickerImageData = [readChildBigStickerArray objectAtIndex:ChildID];
//    if(ChildBigStickerImageData){
//        ChildStickerImage = [UIImage imageWithData:ChildBigStickerImageData];
//        NSLog(@"照片為： %@",ChildStickerImage);
//    }
//    //讀取孩子背景圖片陣列
//    NSArray *readMyChildBackImageArray = [localUserData objectForKey:@"readMyChildBackImageArray"];
//    NSData *readMyChildBackImageData = [readMyChildBackImageArray objectAtIndex:ChildID];
//    if(readMyChildBackImageData) {
//        MyChildBackgroundImage  = [UIImage imageWithData:readMyChildBackImageData];
//        NSLog(@"照片為： %@",MyChildBackgroundImage);
//    }
//    // Prepare the readChildTextFieldnameArray. 準備讀取所創建的孩子名字，根據所選取的孩子ID來決定孩子的名字。
//    readChildTextFieldnameArray = [localUserData objectForKey:@"ChildName"];
    //-- Boen
    

    
    
}
// Initialize  UIEffectView   初始化模糊的上傳狀態view
- (void) initBlurUploadingStatus {
    // 模糊的 上傳狀態的View
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.layer.cornerRadius = 5.0f;
    effectView.layer.masksToBounds = YES;
    effectView.frame = CGRectMake(4, 220, 367, 80);
    _myEffectView = effectView;
    [self.myView addSubview:_myEffectView];
    //_myEffectView.alpha = 0;
    _myEffectView.hidden = YES;
    
    
    
    // 模糊的上面的label
    _myStatusLabel = [[UILabel alloc] initWithFrame:_myEffectView.bounds];
    _myStatusLabel.text = @"上傳中...";
    _myStatusLabel.textAlignment = NSTextAlignmentCenter;
    _myStatusLabel.font = [UIFont systemFontOfSize:20];
    _myStatusLabel.tintColor = [UIColor flatBlackColor];
    //    [effectView.contentView addSubview:label];
    // 在创建的模糊View的上面再添加一个子模糊View
    UIVisualEffectView *subEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)effectView.effect]];
    
    subEffectView.frame = _myEffectView.bounds;
    
    [_myEffectView.contentView addSubview:subEffectView];
    
    [subEffectView.contentView addSubview:_myStatusLabel];
    
    UITapGestureRecognizer *singleT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEffectViewTap)];
    singleT.numberOfTapsRequired = 2;
    singleT.cancelsTouchesInView = NO;
    _myStatusLabel.userInteractionEnabled = YES;
    [_myStatusLabel addGestureRecognizer:singleT];
    
    //-------- end of 模糊的 上傳狀態
}

#pragma mark - 浮動按鈕
// 浮動按鈕
- (void) initBtn2 {
    _plusButtonsViewMain = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4
                                                         firstButtonIsPlusButton:YES
                                                                   showAfterInit:YES
                                                                   actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                            {
                                NSLog(@"actionHandler | title: %@, description: %@, index: %lu", title, description, (long unsigned)index);
                                
                                if(index == 1){
                                    
                                    [self getBabyData];
//                                    [_plusButtonsViewMain hideButtonsAnimated:YES completionHandler:nil];
//                                    [self btnAddNewPostPressed];
                                } else if (index == 2) {
                                    
                                    [_plusButtonsViewMain hideButtonsAnimated:YES completionHandler:nil];
                                    [self btnAddNewPhotosPressed];
                                } else if (index == 3) {
                                    
                                    [_plusButtonsViewMain hideButtonsAnimated:YES completionHandler:nil];
                                    [self btnAddNewFutureMailPressed];
                                }
                                
                                
                            }];
    
    //_plusButtonsViewMain.observedScrollView = self.myCollectionView;
    _plusButtonsViewMain.coverColor = [UIColor colorWithWhite:1.f alpha:0.7];
    //LGPlusButtonsViewPosition *p = ;
    //    _plusButtonsViewMain.position
    _plusButtonsViewMain.position = LGPLusButtonsViewPositionCustom;
    _plusButtonsViewMain.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    [_plusButtonsViewMain setButtonsTitles:@[@"+", @"", @"", @""] forState:UIControlStateNormal];
    [_plusButtonsViewMain setDescriptionsTexts:@[@"", @"日記", @"上傳照片", @"未來的信"]];
    [_plusButtonsViewMain setButtonsImages:@[[NSNull new], [UIImage imageNamed:@"Message"], [UIImage imageNamed:@"Picture"], [UIImage imageNamed:@"Message"]]
                                  forState:UIControlStateNormal
                            forOrientation:LGPlusButtonsViewOrientationAll];
    
    [_plusButtonsViewMain setButtonsAdjustsImageWhenHighlighted:NO];
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_plusButtonsViewMain setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonsTitleFont:[UIFont boldSystemFontOfSize:24.f] forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [_plusButtonsViewMain setButtonsLayerShadowOpacity:0.5];
    [_plusButtonsViewMain setButtonsLayerShadowRadius:3.f];
    [_plusButtonsViewMain setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    [_plusButtonsViewMain setButtonAtIndex:0 size:CGSizeMake(56.f, 56.f)
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 layerCornerRadius:56.f/2.f
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:40.f]
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.f blue:0.5 alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.2 blue:0.6 alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.5 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.6 blue:0.2 alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.7 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    
    [_plusButtonsViewMain setDescriptionsBackgroundColor:[UIColor whiteColor]];
    [_plusButtonsViewMain setDescriptionsTextColor:[UIColor blackColor]];
    [_plusButtonsViewMain setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [_plusButtonsViewMain setDescriptionsLayerShadowOpacity:0.25];
    [_plusButtonsViewMain setDescriptionsLayerShadowRadius:1.f];
    [_plusButtonsViewMain setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [_plusButtonsViewMain setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    for (NSUInteger i=1; i<=3; i++)
        [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, 0.f)
                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
    [self.view addSubview:_plusButtonsViewMain];
    
    
    
    
    
    
}


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
// 新增文字訊息
- (void) btnAddNewPostPressed {
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"addNewMessage" bundle:[NSBundle mainBundle]];
    addNewMessageVC *addNewMessageController = [storyboard instantiateViewControllerWithIdentifier:@"addNewMessageVC"];
    [self.navigationController pushViewController:addNewMessageController animated:YES];
}

- (void) btnAddNewPhotosPressed {
    [self.collection removeAllObjects];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto){
        NSLog(@"photos===%@",photos);
        //[self getImageWithImageView:self.photos tableViewcell:cell];
        
        // 存上傳圖片總數量
        uploadPhotosCount = photos.count;
        //--
        
        for (int i = 0; i<uploadPhotosCount; i++){
            
        //      上傳圖片
        // 上傳管理員
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        
        // 上傳暫存檔路徑
        UIImage *image = [photos objectAtIndex:i];
        NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
        NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"] stringByAppendingPathComponent:fileName];
        NSData * imageData = UIImagePNGRepresentation(image);
        
        [imageData writeToFile:filePath atomically:YES];
        
            // 將檔名存入準備寫入SQL的格式
            [upFileNames appendString:fileName];
            if(i != uploadPhotosCount-1){
                [upFileNames appendString:@","];
            }
            NSString *thisPostType;
            if (uploadPhotosCount == 1) {
                thisPostType = @"2";
                
            } else if (uploadPhotosCount == 2) {
                thisPostType = @"3";
            } else if (uploadPhotosCount >= 3) {
                thisPostType = @"4";
            }
            
        
        NSLog(@" # # FileName: %@", fileName);
        
        // 上傳request
        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
        uploadRequest.body = [NSURL fileURLWithPath:filePath];
        uploadRequest.key = fileName;
        uploadRequest.bucket = @"the.timealbum";
            
            uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
                NSLog(@"%lld / %lld --", totalBytesSent,totalBytesExpectedToSend);
            };
        
        [self.collection addObject:uploadRequest];
            
             // 上傳要開始時 讓顯示上傳狀態的東西顯示出來
            _myEffectView.hidden = NO;
        //[self.myCollectionView reloadItemsAtIndexPaths:@[@0]];
        [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
            if (task.error) {
                if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                    switch (task.error.code) {
                        case AWSS3TransferManagerErrorCancelled:
                        case AWSS3TransferManagerErrorPaused:
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                               
                                //上傳失敗暫停
                                 NSLog(@" # # 圖片上傳暫停");
                            });
                        }
                            break;
                            
                        default:
                            NSLog(@" # # 圖片上傳失敗1: [%@]", task.error);
                            break;
                    }
                } else {
                    NSLog(@" # # 圖片上傳失敗2: [%@]", task.error);
                }
            }
            
            if (task.result) {
                uploadedPhotosCount += 1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 圖片上傳成功喔
                    NSLog(@" # # 圖片上傳成功 %ld / %ld", (long)uploadedPhotosCount, (long)uploadPhotosCount);
                    self.myStatusLabel.text = [NSString stringWithFormat:@"上傳中...( %ld/ %ld)", uploadedPhotosCount, uploadPhotosCount];
                    
                    
                    
                    
                    
                    // 如果全都上傳完了 寫入資料庫 重置東西
                    if ( uploadedPhotosCount == uploadPhotosCount) {
                        // 寫入資料庫
                        NSLog(@" %@" , upFileNames);
                        [comm sendTextMessage:upFileNames
                                    forbabyID:[localUserData objectForKey:@"babyid"]
                                     postType:thisPostType
                                   completion:^(NSError *error, id result) {
                                       if(error){
                                           NSLog(@"Do sendPhotos fail: %@", error);
                                           //[KVNProgress showErrorWithStatus:@"失敗 請重試"];
                                           return;
                                       }
                                       NSLog(@"==--%@", result);
                                       // 伺服器php指令是否成功
                                       if([result[RESULT_KEY] boolValue] == false){
                                           NSLog(@"Update PhotosMessage to sql failed: %@", result[ERROR_CODE_KEY]);
                                           //[KVNProgress showErrorWithStatus:@"失敗 請重試"];
                                           return;
                                       }
                                       
                                       //[KVNProgress dismissWithCompletion:^{
                                       // Things you want to do after the HUD is gone.
                                       //[KVNProgress showSuccessWithStatus:@"新增成功"];
                                       
                                       //[self.navigationController popViewControllerAnimated:YES];
                                       
                                       // }];
                                       [self doReloadJob];
                                   }]; // end of comm sendTextMessage
                        // 上傳要結束時 讓顯示上傳狀態的東西隱藏
                        _myEffectView.hidden = YES;
                        uploadPhotosCount = 0;
                        uploadedPhotosCount = 0;
                        totalBit = 0;
                        nowBit = 0;
                        [upFileNames setString:@""];
                        NSLog(@"%@", upFileNames);
                    }
                    
                    
                    
                    
                });
                
                
            }
            
            return nil;
        }];
        //[self.myCollectionView reloadItemsAtIndexPaths:@[@0]];
        
    } // end of for loop
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}

- (void) btnAddNewFutureMailPressed {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"futureMail" bundle:[NSBundle mainBundle]];
    WriteMailViewController *nextPage = [storyboard instantiateViewControllerWithIdentifier:@"WriteMailViewController"];
    [self presentViewController:nextPage animated:YES completion:nil];
}


#pragma mark - default implements method    基本繼承方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServe {

    if([[UseDownloadDataClass object] ReadSuccessUpdateBool]) {
        NSLog(@"下載資料開始");
        //        downloadChildBigSticker.hidden = false;
        //開始下載網路上儲存的資料
        UpdateDataView *downloadChildBigSticker = [UpdateDataView new];
        [downloadChildBigSticker DowloadChildBigSticker:^(NSArray *array) {
            readChildBigStickerArray  = array;
            NSLog(@"Block 所讀取到的資料為： %@",readChildBigStickerArray);
            //將成功下載的孩子大頭貼陣列資料傳到全域變數來使用
            [[UseDownloadDataClass object] PutChildBigStickerArray:readChildBigStickerArray];
            //設定通知結束 SetInfoTableViewControler 進行更新
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SetInfoTableViewControler" object:nil];
            //通知執行 SliderMenuViewLeft 進行更新
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"updateTableViewContrler" object:nil];
            //設定通知結束 FutureMailViewController 進行更新
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"FutureMailViewController" object:nil];
            //下載成功後傳送 BOOL 值結束結束重複下載，如果要在執行下載必須有更新資料才會執行下載。
            [[UseDownloadDataClass object] PutSuccessUpdateBool:false];
        }];
        
    }
}



-(void) viewWillAppear:(BOOL)animated{
    
    [self downloadDataFromServe];

    
    //[self initBtn2];
    
    //////////////-=========================================
    //FIXME: tabbar隱藏
    self.tabBarController.tabBar.hidden = NO;
    
    
    // Boen
    //讀取是否已有建立第一個孩子.
    NSUserDefaults *readChildNameDefaults;
    readChildNameDefaults = [NSUserDefaults standardUserDefaults];
    //如果讀出的陣列數量為零的話，就執行 AddChildSettingViewController 來創造第一個孩子。
    NSArray *readChildNameArray = [readChildNameDefaults objectForKey:@"ChildName"];
    if(readChildNameArray.count == 0) {
        StartCreateFirstChildViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"StartCreateFirstChildViewController"];
        [self presentViewController:nextPage animated:YES completion:nil];
    }
    //-- Boen

    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    //[self doReloadJob];
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
    
    PostItem *pp =[postItems objectAtIndex:indexPath.row];
    MyCollectionViewCellWithText *cell;
    MyCollectionViewCellWithImage3 *cell4;
    MyCollectionViewCellUploading *cell5;
    // postype = 1
    if ( pp.postType == PostTypeText ){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCellWithText" forIndexPath:indexPath];
    // postype = 4
    } else if(pp.postType == PostTypeThreePic) {
        
        cell4 = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCellWithImage3" forIndexPath:indexPath];
        
    // postype = 5
    } else if(pp.postType == PostTypeUploading) {
        
        cell5 = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCellUploading" forIndexPath:indexPath];
        
    }
    
    
    
    //MyCollectionViewCellWithImage1 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"onePicCell" forIndexPath:indexPath];
    
    //cell.image = self.images[indexPath.item%(self.images.count)];
    //
    if(postItems.count == 0) {
        cell.titleText.text = [NSString stringWithFormat:@"%ld",indexPath.item ];
        cell.detalText.text = [NSString stringWithFormat:@"12134567890-09876543245678909876543234567 %ld", indexPath.item];
    } else {
        if ( pp.postType == PostTypeText ) {
            //cell.titleText.text = [NSString stringWithFormat:@"第 %ld 天",postItems.count -indexPath.item ];
            cell.titleText.text = pp.postDateString;
            cell.detalText.text = pp.content;
            
            
            return cell;
            
        } else if ( pp.postType == PostTypeThreePic) {
            
            if(pp.image1 == nil){
            
            } else {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //NSLog(@"index path at cell for item : % ld", indexPath.row);
                    cell4.image01.image = pp.image1;
                    cell4.image02.image = pp.image2;
                    cell4.image03.image = pp.image3;
                
                });
                
                
            }
            cell4.labelNumOfPhotos.text = [NSString stringWithFormat:@" 共 %ld 張相片", pp.photoNum2];
            cell4.labelDate.text = pp.postDateString;
            
            return cell4;
        
        } else if ( pp.postType == PostTypeUploading) {
            
            //cell5.statusLabel.text = @"Uploading.. 1/5";
            //cell5.progressView.progress = 0;
            
            //cell5.statusLabel.text = [NSString stringWithFormat:@"%f",(float)((double) nowBit / totalBit)];
            //NSLog(@"%lld, %lld -", nowBit,totalBit);
            //cell5.progressView.progress = (float)((double) nowBit / totalBit);
            
            
            id object;
            if (self.collection.count != 0){
                 object = [self.collection objectAtIndex:indexPath.row];
            }
            if ([object isKindOfClass:[AWSS3TransferManagerUploadRequest class]]) {
                AWSS3TransferManagerUploadRequest *uploadRequest = object;
                
                switch (uploadRequest.state) {
                    case AWSS3TransferManagerRequestStateRunning: {
                        
                        
                //  即時載入 在cell裡的進度條
//                        uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                if (totalBytesExpectedToSend > 0) {
//                                    //cell5.statusLabel.text = [NSString stringWithFormat:@"%f",(float)((double) nowBit / totalBit)];
//                                    cell5.progressView.progress = (float)((double) totalBytesSent / totalBytesExpectedToSend);
//                                NSLog(@"%lld / %lld", totalBytesSent, totalBytesExpectedToSend);
//                                    //cell5.progressView.progress = (float)((double) nowBit / totalBit);
//                                }
//                            });
//                        };  //end of uploadprogress
                        
                    }
                        break;
                        
                    case AWSS3TransferManagerRequestStateCanceling:
                    {
                        
//                        cell5.label.hidden = NO;
//                        cell5.label.text = @"Cancelled";
                    }
                        break;
                        
                    case AWSS3TransferManagerRequestStatePaused:
                    {
//                        cell5.imageView.image = nil;
//                        cell5.label.hidden = NO;
//                        cell5.label.text = @"Paused";
                    }
                        break;
                        
                    default:
                    {
//                        cell5.imageView.image = nil;
//                        cell5.label.hidden = YES;
                    }
                        break;
                }
            } else if ([object isKindOfClass:[NSURL class]]) {
                NSURL *downloadFileURL = object;
                cell5.progressView.progress = 1.0f;
            }
            
            return cell5;
        }
        
    }
    
    return nil;
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
    
    
    // 判斷下一頁是哪種頁面
    if (tempItem.postType == PostTypeText){
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"EditTextPost" bundle:[NSBundle mainBundle]];
        EditTextPostViewController *editController = [storyboard instantiateViewControllerWithIdentifier:@"EditTextPostVC"];
        // FIXME: 傳到下一頁的資料
        editController.titleString = tempItem.postDateString;
        editController.contentString = tempItem.content;
        editController.postID = tempItem.postID;
        
        [self.navigationController pushViewController:editController animated:YES];
    } else if(tempItem.postType == PostTypeThreePic) {
        
        //UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"ImageViewController" bundle:[NSBundle mainBundle]];
        //ImageViewController *imageViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
        
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"ImagePageViewController" bundle:[NSBundle mainBundle]];
        ImagePageViewController *imagePageViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImagePageViewController"];
        
        imagePageViewController.allImageNameStr = tempItem.content;
        //FIXME: tabbar隱藏
        //imageViewController.hidesBottomBarWhenPushed = YES;
        self.tabBarController.tabBar.hidden = YES;
        
        [self.navigationController pushViewController:imagePageViewController animated:YES];
        
        //[self presentViewController:imageViewController animated:YES completion:nil];
        
        
    } else if (tempItem.postType == PostTypeUploading) {
        
        
    }
    

    
    
    //collectionView dis
    
    
    
}
- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//- (CGSize) collectionView:(UICollectionView *) collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    
//    PostItem *pp = [postItems objectAtIndex:indexPath.row];
//    
//    if(pp.postType == 1){
//        return CGSizeMake(349, 250);
//    } else {
//        return CGSizeMake(349, 350);
//    }
//    
//}




#pragma mark - doReloadJob    網路接收 處理資料
// 從網路載入貼文內容
- (void) doReloadJob {
    NSLog(@"1afjkj;lfj=======");
    
    //FIXME: Hard Code
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
                                    
                                    NSInteger howManyPosts = items.count;
                                    
                                    // Handle new messages
                                    [incomingPosts addObjectsFromArray:items];
                                    NSLog(@"do before handle messager");
                                    [self handleIncomingMessages: howManyPosts];
                                    NSLog(@"afjkj;lfj=======");
                                }];
    
}

//處理暫存區array的功能
//----------------------------------------------------------------------------------
-(void) handleIncomingMessages: (NSInteger) howManyPosts{
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
    // 暫存的 總共有幾個post 用來幫助postitem存indexpath
    NSInteger postNumTotal = howManyPosts;
    NSInteger reducingPostsNum = incomingPosts.count;
    //NSIndexPath *itemIndex = [NSIndexPath indexPathWithIndex:postNumTotal-reducingPostsNum];
    NSInteger itemIndex = postNumTotal-reducingPostsNum;
    NSLog(@"= = the indexpath : %ld", itemIndex);
    
    
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
    item.itemIndex = itemIndex;
    
   
    
   
    
    //item.image =
    
    if(postType == 1){
        item.postType = PostTypeText;
    } else if(postType == 2) {
        item.postType = PostTypeOnePic;
    } else if(postType == 3) {
        item.postType = PostTypeTwoPic;
    } else if(postType == 4) {
        item.postType = PostTypeThreePic;
    } else if(postType == 5) {
        item.postType = PostTypeUploading;
    }
    
    [postItems addObject:item];
    //FIXME: static array 可能會有問題
    [self.myStaticArray  addObject:item];
    
    if(postType == PostTypeText){   //Text Message
        //[_chatView addChatItem:item]; //+
        
        // 如果post type 是文字
        [self handleIncomingMessages: howManyPosts];
    } else if(postType == PostTypeThreePic){
        // 三張圖以上 下載啦！
        NSArray *picNames = [displayMessage componentsSeparatedByString:@","];
        BOOL shouldDownload = YES;
        NSInteger countingPos2=0;
        for(int i=0; i<picNames.count; i++){
            //NSLog(@"%@", picNames[i]);
            NSString *picName = picNames[i];
            NSString *downloadingFilePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"] stringByAppendingPathComponent:picName];
            NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
            
            
            
            // 檢查圖片是否已暫存 是的話就不下載
            NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"download"];
            NSFileManager *fileM = [NSFileManager defaultManager];
            NSArray * a = [fileM contentsOfDirectoryAtPath:directory error:nil];
            for(NSString *temp in a){
                
                
                if([picName isEqualToString: temp]){
                    NSLog(@"- - 圖片已存在: %@", temp);
                    shouldDownload = NO;
                    
                    
                    
                    // 將以暫存的圖檔放入post item 好讓collectionview 載入
                    PostItem *tempPP = [postItems objectAtIndex:itemIndex];
                    NSLog(@" item index at putting pics into postitem: %ld", itemIndex);
                    
                    
                    tempPP.photoNum2  = picNames.count;
                    
                    if(countingPos2 == 0){
                        tempPP.image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadingFileURL]];
                        NSLog(@"寫到了");
                        
                        // 如果post裡的圖全跑完了 就歸零
                        countingPos2++;
                        if(countingPos2 == picNames.count){
                            countingPos2 = 0;
                        }
                    } else if ( countingPos2 == 1 ){
                        tempPP.image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadingFileURL]];
                        
                        countingPos2++;
                        if(countingPos2 == picNames.count){
                            countingPos2 = 0;
                        }
                    } else if ( countingPos2 == 2 ){
                        tempPP.image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadingFileURL]];
                        
                        countingPos2++;
                        if(countingPos2 == picNames.count){
                            countingPos2 = 0;
                        }
                    }
                    // --
                    break;
                }
            }
            
            if ( !shouldDownload ){
                shouldDownload = YES;
                continue;
            }
            //
        
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
                    for(NSString *temp in a){
                        NSLog(@"- - temp: %@", temp);
                    }
                    //NSLog(@"%@", task.result);
                
                    //AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
                    NSLog(@" - - - - pic download success....");
                    
                    // 將下載回來的圖片放入postitem以讓 collectionview 載入
                    PostItem *tempPP = [postItems objectAtIndex:itemIndex];
                    if(countingPos == 0){
                        tempPP.image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadingFileURL]];
                    
                    
                        // 如果post裡的圖全跑完了 就歸零
                        countingPos++;
                        if(countingPos == picNames.count){
                            countingPos = 0;
                        }
                    } else if ( countingPos == 1 ){
                        tempPP.image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadingFileURL]];
                    
                        countingPos++;
                        if(countingPos == picNames.count){
                            countingPos = 0;
                        }
                    } else if ( countingPos == 2 ){
                        tempPP.image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:downloadingFileURL]];
                    
                        countingPos++;
                        if(countingPos == picNames.count){
                            countingPos = 0;
                        }
                    }
                    //[_myCollectionView reloadItemsAtIndexPaths:@[indexpath]];
                    [_myCollectionView reloadData];
                }
                return nil;
            }];
        }   // end of for loop
        
        
        
        
        
        
        
        
        
        
        [self handleIncomingMessages: howManyPosts];
    
    } else if(postType == PostTypeUploading){
        // 正在上傳的cell
        
        [self handleIncomingMessages: howManyPosts];
        
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
    
    
    [comm getBabyDataByUID:localUID
                           completion:^(NSError *error, id result) {
                               // AFN 連線是否成功
                               if(error){
                                   NSLog(@"** getBabyDataByUID Fail: %@", error);
                                   //[self doReloadJob];
                                   return;
                               }
                               // 伺服器php指令是否成功
                               if([result[RESULT_KEY] boolValue] == false){
                                   NSLog(@"** getBabyDataByUID Fail: %@", result[ERROR_CODE_KEY]);
                                   //[self doReloadJob];
                                   return;
                               }
                               //取回來的 成就們的 陣列
                               NSArray *items = result[@"BabysArr"];
                               NSLog(@"Receive achievements: %lu", items.count);
                               
                               // 如果名下都沒有寶寶
                               if(items.count == 0){
                                   NSLog(@"No baby , do nothing and return.");
                                   return;
                               }
                               //[getAchievementItems removeAllObjects];
                               
                               
                               // Handle new messages
                               //[incomingAchievements addObjectsFromArray:items];
                               NSLog(@"** do before getBabyData");
                               [self handleIncomingMessages:items.count];
                               NSLog(@"** done with getBabyData");
                               
                               //NSLog(@" %lu, %lu, ", (unsigned long)incomingAchievements.count, (unsigned long)getAchievementItems.count);
                               
                           }];
    
    //NSLog(@"aaa uid : %@",localUID);
    //[comm getBabyDataByBabyID:babyID ];

}




#pragma mark - didScroll   滾動畫面改變的功能
// Adjust headview and navigationbar by scrolling the view
// 捲動畫面時改變header大小及navbar透明度的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_Y = scrollView.contentOffset.y + headRect.size.height;
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
        
    } else if(offset_Y > (headRect.size.height-navHeight-navHeight)) {
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
    
    //
    if (offset_Y <0){
        
        // 上傳狀態 view
        _myEffectView.frame = CGRectMake(4, 220 - offset_Y, 367, 80);
    } else if (offset_Y >0 && offset_Y < 154) {
        // 上傳狀態 view
        _myEffectView.frame = CGRectMake(4, 220 - offset_Y, 367, 80);
    } else if ( offset_Y > 154){
        _myEffectView.frame = CGRectMake(4, 64, 367, 80);
        // 上傳狀態 view
    }
    CGFloat offsetYofheader = headRect.size.height-navHeight-navHeight - 64;
    // 印出
    //NSLog(@"off: %f", offsetYofheader);
    //NSLog(@"offsetY : %f", offset_Y);
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
