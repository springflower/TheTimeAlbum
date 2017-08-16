//
//  SliderMenuView.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//


#import "ViewController.h"
#import "SliderMenuViewLeft.h"
#import <ChameleonFramework/Chameleon.h>
#import "SliderMenuLeftTableViewCell.h"
#import "AddChildSettingViewController.h"

#define MYCHILDNAME @"我的孩子"

@implementation SliderMenuViewLeft
{
    
    CGPoint lastLocation;
    CGRect fullScreenBounds;
    UITableView *MenuTableView;
    int targetPageID;
    NSUserDefaults *defaults;
    UIPanGestureRecognizer *putWayLeftMenu;
    NSArray *readChildBigStickerArray;
    NSArray *readChildTextFieldnameArray;
    NSArray *readChildBirthdayFieldArray;

}
-(id)init{
    self=[super init];
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
//    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan2:)];
//    [pan setEdges:UIRectEdgeRight];
//    [pan setDelegate:self];
//    [self addGestureRecognizer:pan];

    putWayLeftMenu= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
    [self addGestureRecognizer:putWayLeftMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hidden) name:@"hiddenLeftMenu" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(putAwayLeftMenu) name:@"putAWayLeftMenu" object:nil];
    
    if (self) {
        //        預設畫面比例
        self.MenuScreenScale=0.5;
        //        預設頁面切換時間
        self.SwichingPageSpeed=0.25;
        //        預設下次畫面切換為不切換
        targetPageID=999;
        //        設定基本大小
        //CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];//取得收機畫面大小
        self.frame=CGRectMake((-fullScreenBounds.size.width*self.MenuScreenScale),20, fullScreenBounds.size.width*self.MenuScreenScale,fullScreenBounds.size.height);
        self.backgroundColor=[UIColor flatSkyBlueColor];
        self.layer.cornerRadius=25.0;
        self.clipsToBounds = YES;
//        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor flatBlackColor].CGColor;
        self.layer.masksToBounds = YES;
        //self.alpha = 0.8;
        

        /*
        //收Menu 的 Button
        UIButton *MenuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        MenuButton.frame=CGRectMake(0,0, 44, 42);
        [MenuButton setImage:[UIImage imageNamed:@"清單48x48@2x.png"] forState:UIControlStateNormal];
        [MenuButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];//按下去時呼叫 callMenu 方法來收起 Menu
        [self addSubview:MenuButton];
        */
        [self addMenu];
        
        
        //建立孩子的 label
        UILabel * MyChildName=[UILabel new];
        MyChildName.text = MYCHILDNAME;
        MyChildName.frame=CGRectMake(10, 8, 100,100);
        MyChildName.textColor = [UIColor whiteColor];
        [self addSubview:MyChildName];
        
        
        //建立孩子的 button
        UIButton *AddChild = [UIButton new];
        AddChild.frame=CGRectMake(140,38, 40, 40);
        [AddChild setTitle:@"添加" forState:UIControlStateNormal];
        [AddChild addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:AddChild];
        
    }
    return self;
    
}

-(void)hidden {
    self.hidden = true;
}
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
    // Set ViewListPosition if smaller or bigger the setting Value, carried out the animated. 設定左側選單觸發事件結束時，執行所設定的數值執行動畫.
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        if(self.frame.origin.x < -100 ) {
            [UIView beginAnimations:@"inMenu" context:nil];
            [UIView setAnimationDelegate:self];
            self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,20,
                                  fullScreenBounds.size.width*self.MenuScreenScale,
                                  fullScreenBounds.size.height-22);
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:@"inMenu" context:nil];
            [UIView setAnimationDelegate:self];
            self.frame=CGRectMake(0,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
            [UIView commitAnimations];
        }
    }
    
}

-(IBAction)next:(id)sender {
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDelegate:self];
    self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settingChild" object:nil];
}

-(void)putAwayLeftMenu {
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDelegate:self];
    self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
    [UIView commitAnimations];
}

-(void)addMenu{
    // Set TableView.
    MenuTableView=[[UITableView alloc] init];
    MenuTableView.delegate=self;
    MenuTableView.dataSource=self;
    MenuTableView.allowsSelection=YES;
    MenuTableView.frame=CGRectMake(0,70, self.frame.size.width, self.frame.size.height+20);
    //MenuTableView.backgroundColor = [UIColor flatPowderBlueColor];
    // To clean the tableView line Between. 去除 tableView cell 與 cell 之間的分隔線.
    //MenuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addSubview:MenuTableView];
    
}

-(void)callMenu{
    //準備讀取存取的孩子姓名陣列
    readChildTextFieldnameArray = [defaults objectForKey:@"ChildName"];
    //準備讀取存取的孩子生日陣列
    readChildBirthdayFieldArray = [defaults objectForKey:@"ChildBirthday"];
    //準備讀取存取的孩子大頭貼陣列
    readChildBigStickerArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyBigSticker"];
    //準備 MenuTableView 重新更新一次
    [MenuTableView reloadData];
    //解除 SliderMenuViewLeft 本身的隱藏
    self.hidden = false;
    //準備 SliderMenuViewLeft 的動畫
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDuration:self.SwichingPageSpeed];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(SwichingPage)];
    
    if (self.frame.origin.x==-fullScreenBounds.size.width*self.MenuScreenScale) {
        self.frame=CGRectMake(0,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
    } else{
        targetPageID=999;//出現選單時重設目標
        self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
    }
    [UIView commitAnimations];
    
}


-(void)SwichingPage{
    if (targetPageID!=999) {//如果是選單出現時，不需要在完成動畫時切換tab
         AppDelegate *AppDele =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [((UITabBarController *)AppDele.window.rootViewController) setSelectedIndex:targetPageID];
        [MenuTableView removeFromSuperview];
        [self addMenu];
    }
}

#pragma -mark TableView Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return readChildTextFieldnameArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SliderMenuLeftTableViewCell *myCell=[[SliderMenuLeftTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Menu"];
 
    //myCell.backgroundColor = [UIColor flatPowderBlueColor];
    for(int x=0;x <=indexPath.section;x++) {
        myCell.textLabel.text=[readChildTextFieldnameArray objectAtIndex:x];
        myCell.detailTextLabel.text = [NSString
                                       stringWithFormat:@"生日:%@",[readChildBirthdayFieldArray objectAtIndex:x]];
        NSData *readMyBigStickerData = [readChildBigStickerArray objectAtIndex:x];
        UIImage*BigStickerImage = [UIImage imageWithData:readMyBigStickerData];
        myCell.imageView.image = BigStickerImage;
    }
//    [myCell.textLabel setTextAlignment:NSTextAlignmentRight];
//    [myCell.detailTextLabel setTextAlignment:NSTextAlignmentLeft];
    
    //if(readMyBigStickerArray.count != 0){

    //}
    return myCell;
}

#pragma mark -UITableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger ChildID = indexPath.section;
    [defaults setInteger:ChildID forKey:@"ChildID"];
    [defaults synchronize];
    
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDelegate:self];
    self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
    [UIView commitAnimations];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

        return @" ";

}




@end
