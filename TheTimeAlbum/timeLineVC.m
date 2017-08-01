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
#import "textLayout.h"
#import <BFPaperButton.h>
#import "addNewMessageVC.h"
#import <Chameleon.h>
#import "MyAccountData.h"
#import "MyCommunicator.h"

@interface timeLineVC ()<UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource>
{
    MyAccountData *currentuser;
    NSUserDefaults *localUserData;
    MyCommunicator *comm;
}
@property (weak, nonatomic) UITableView *myTableView;
@property (weak, nonatomic) UICollectionView *myCollectionView;
@property (weak, nonatomic) HeadView * myView;

// 半透明navgation bar
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, assign) CGFloat topContentInset;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, assign) BOOL statusBarStyleControl;
//--

@end

@implementation timeLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 半透明navgation bar
    _statusBarStyleControl = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //self.navigationController.navigationBar.translucent = true;
    //--
    
    // About user data.         用戶資料存取
    localUserData = [NSUserDefaults standardUserDefaults];
    currentuser = [MyAccountData sharedCurrentUserData];
    NSLog(@"_____id: %@, mail: %@, gender: %@, name: %@", currentuser.userId, currentuser.userMail, currentuser.gender, currentuser.userName);
    //--
    
    // 初始化collection view
    [self initCollectionView];
    
    // 初始化標頭view
    [self initHeadView];
    
    //初始化浮動按鈕
    [self initBtn];
    
}
//
- (void) initCollectionView {
    // Collection view's layout about text message.     collectionview中文字訊息的layout
    textLayout *myTextLayout = [[textLayout alloc] init];
    
    UICollectionView * myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navHeight-NAV_BAR_HEIGHT, VCWidth, VCHeight) collectionViewLayout:myTextLayout];
    
    // collection view setting
    myCollectionView.backgroundColor = [UIColor flatWhiteColor];
    [myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCellWithText" bundle:nil]  forCellWithReuseIdentifier:@"message"];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.contentInset = UIEdgeInsetsMake(headRect.size.height-navHeight-navHeight, 0, 0, 0);
    _myCollectionView = myCollectionView;
    [self.view addSubview:myCollectionView];
}

//...
- (void) initScaleImageView {
    
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VCHeight, VCWidth*435.5/414.0)];
    //_topImageView.backgroundColor = [UIColor whiteColor];
    _topImageView.image = [UIImage imageNamed:@"Fox"];
    [self.view addSubview:_topImageView];
    //[self.view insertSubview:_topImageView belowSubview:_myCollectionView];
}
//--
// Initial HeadView      初始化標頭view元件
- (void) initHeadView {
    
    HeadView * vc = [[HeadView alloc]initWithFrame:headRect backgroundView:@"Fox.jpg" headView:@"c.png" headViewWidth:(CGFloat)(VCWidth / 4) signLabel:@"王小明"];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{

    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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

// collection implement methods
//------------------------------------------------------------------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 5;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *onePicID = @"onePicCell";
    static NSString *twoPicID = @"twoPicCell";
    static NSString *threePicID = @"threePicCell";
    static NSString *mailID = @"mailCell";
    static NSString *textMessageID = @"texMessageCell";
    
    MyCollectionViewCellWithText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"message" forIndexPath:indexPath];
    //cell.image = self.images[indexPath.item%(self.images.count)];
    //
    cell.titleText.text = [NSString stringWithFormat:@"%ld",indexPath.item ];
    cell.detalText.text = [NSString stringWithFormat:@"12134567890-09876543245678909876543234567 %ld", indexPath.item];
    return cell;
}
//--

// Adjust headview and navigationbar by scrolling the view
// 捲動畫面時改變header大小及navbar透明度的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_Y = scrollView.contentOffset.y + headRect.size.height;
    if  (offset_Y < 0) {
        
        _myView.backgroundView.contentMode = UIViewContentModeScaleToFill;
        
        _myView.backgroundView.frame = CGRectMake(offset_Y*0.5 , -navHeight, VCWidth - offset_Y, headRect.size.height - offset_Y);
    }else if (offset_Y > 0 && offset_Y <= (headRect.size.height-navHeight-navHeight)) {
        
        _myView.backgroundView.contentMode = UIViewContentModeTop;
        
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
        
        _alphaMemory = offset_Y/(offsetYofheader * 3) >= 1 ? 1 : offset_Y/(offsetYofheader * 3);
        
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
        
    }
    else if (offset_Y <= offsetYofheader*3) {
        
        _statusBarStyleControl = NO;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        _alphaMemory = 0;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    }
    else if (offset_Y > offsetYofheader*3) {
        _alphaMemory = 1;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    }
    
    
    
}
//------------------------------------------------------------------



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
