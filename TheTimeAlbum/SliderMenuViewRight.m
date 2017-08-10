//
//  SliderMenuRight.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "SliderMenuViewRight.h"
#import <ChameleonFramework/Chameleon.h>

@implementation SliderMenuViewRight
{
    CGPoint lastLocation;
    CGRect fullScreenBounds;
    UIPanGestureRecognizer *putWayRightMenu;
    NSMutableArray *MenuArray;
    UITableView *MenuTableView;
    int targetPageID;
}
-(id)init{
    self=[super init];
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    
    putWayRightMenu= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
    [self addGestureRecognizer:putWayRightMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(putAwayRightMenu) name:@"putAwayRightMenu" object:nil];

    
    if (self) {
        self.hidden = true;
        //        設定Menu 資料來源
        MenuArray=[[NSMutableArray alloc] initWithCapacity:50];
        [MenuArray addObject:@"一"];

        //        預設畫面比例
        self.MenuScreenScale=0.5;
        //        預設頁面切換時間
        self.SwichingPageSpeed=0.25;
        //        預設下次畫面切換為不切換
        targetPageID=999;
        
        //        設定基本大小
        self.frame=CGRectMake((fullScreenBounds.size.width*self.MenuScreenScale)*2,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
        self.backgroundColor=[UIColor flatSkyBlueColor];
        self.layer.cornerRadius=25.0;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor flatBlackColor].CGColor;
        self.layer.masksToBounds = YES;
        //self.alpha = 0.8;
        
        
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(44, 0, self.frame.size.width-44, 42)];
        //        titleLabel.text=@"選單項目";
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:titleLabel];
        
        
        //        收Menu 的 Button
        UIButton *MenuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        MenuButton.frame=CGRectMake(0,0, 44, 42);
        [MenuButton setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
        [MenuButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];//按下去時呼叫 callMenu 方法來收起 Menu
        [self addSubview:MenuButton];
        [self addMenu];
        
        
    }
    return self;
    
}

-(void) putAwayRightMenu {
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDelegate:self];
    self.frame=CGRectMake((fullScreenBounds.size.width*self.MenuScreenScale)*2,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
    [UIView commitAnimations];
}

// Set fingerTouch event. 設定手指觸發事件來移動清單.
-(void)detectPan:(UIPanGestureRecognizer*)recognizer {
    CGPoint translation =  [recognizer translationInView:self.superview];
    
    // Set ViewListPosition not move out settiing position. 設定左側清單被移動時不能超過設定的位置.
    if(self.frame.origin.x < fullScreenBounds.size.width*self.MenuScreenScale) {
        self.frame=CGRectMake(fullScreenBounds.size.width*self.MenuScreenScale,20,fullScreenBounds.size.width*self.MenuScreenScale,fullScreenBounds.size.height-22);
        NSLog(@"%f",self.frame.origin.x);
        
    }else if(fullScreenBounds.size.width*self.MenuScreenScale+translation.x > fullScreenBounds.size.width*self.MenuScreenScale){
        self.frame=CGRectMake(fullScreenBounds.size.width*self.MenuScreenScale+translation.x,20,
                              fullScreenBounds.size.width*self.MenuScreenScale,
                              fullScreenBounds.size.height-22);
    }
    // Set ViewListPosition if smaller or bigger the setting Value, carried out the animated. 設定左側選單觸發事件結束時，執行所設定的數值執行動畫.
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        if(self.frame.origin.x >  fullScreenBounds.size.width*self.MenuScreenScale +100) {
            [UIView beginAnimations:@"inMenu" context:nil];
            [UIView setAnimationDelegate:self];

            self.frame=CGRectMake((fullScreenBounds.size.width*self.MenuScreenScale)*2,20,
                                  fullScreenBounds.size.width*self.MenuScreenScale,
                                  fullScreenBounds.size.height-22);
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:@"inMenu" context:nil];
            [UIView setAnimationDelegate:self];
            self.frame=CGRectMake(fullScreenBounds.size.width*self.MenuScreenScale,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
            [UIView commitAnimations];
        }
    }
    
}

-(void)addMenu{
    
    //設定Table 代理人
    MenuTableView=[[UITableView alloc] init];
    MenuTableView.dataSource=self;
    MenuTableView.delegate=self;
    MenuTableView.frame=CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-44);
    MenuTableView.allowsSelection=YES;
    [self addSubview:MenuTableView];
    
}

-(void)callMenu{
    self.hidden = false;
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDuration:self.SwichingPageSpeed];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(SwichingPage)];
    
    if (self.frame.origin.x==(fullScreenBounds.size.width*self.MenuScreenScale)*2) {
        self.frame=CGRectMake(fullScreenBounds.size.width*self.MenuScreenScale,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
        NSLog(@"%f",fullScreenBounds.size.width*self.MenuScreenScale);
    }else{
        targetPageID=999;//出現選單時重設目標
        self.frame=CGRectMake((fullScreenBounds.size.width*self.MenuScreenScale)*2,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height-22);
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MenuArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *myCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Menu"];
    myCell.textLabel.text=[MenuArray objectAtIndex:indexPath.row];
    [myCell.textLabel setTextAlignment:NSTextAlignmentLeft];
    myCell.imageView.image=[UIImage imageNamed:@"icon_menu.png"];
    
    return myCell;
}

#pragma mark -UITableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self callMenu];
    targetPageID=indexPath.row;//設定目標 tab ID
}

@end
