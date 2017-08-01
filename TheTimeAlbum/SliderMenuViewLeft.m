//
//  SliderMenuView.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "SliderMenuViewLeft.h"
#import "ViewController.h"
#import "AddChildSettingViewController.h"

#define MYCHILDNAME @"我的孩子"

@implementation SliderMenuViewLeft
{
    CGPoint lastLocation;
    CGRect fullScreenBounds;
    NSMutableArray *MenuArray;
    NSMutableArray <UIImage*>*ImageMenuArray;
    UITableView *MenuTableView;
    int targetPageID;
    NSUserDefaults *defaults;
    UIPanGestureRecognizer *MoveView;

}
-(id)init{
    self=[super init];
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    lastLocation.x = 0;
    
//    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan2:)];
//    [pan setEdges:UIRectEdgeRight];
//    [pan setDelegate:self];
//    [self addGestureRecognizer:pan];

    MoveView= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
    [self addGestureRecognizer:MoveView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:@"hiddenLeftMenu" object:nil];
    
    if (self) {
        //        設定Menu 資料來源
        MenuArray=[[NSMutableArray alloc] initWithCapacity:50];
        ImageMenuArray=[NSMutableArray new];
        
        [MenuArray addObject:@"一"];
        

        
        //        預設畫面比例
        self.MenuScreenScale=0.5;
        //        預設頁面切換時間
        self.SwichingPageSpeed=0.25;
        //        預設下次畫面切換為不切換
        targetPageID=999;
        //        設定基本大小
        //CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];//取得收機畫面大小
        self.frame=CGRectMake((-fullScreenBounds.size.width*self.MenuScreenScale),20, fullScreenBounds.size.width*self.MenuScreenScale,fullScreenBounds.size.height);
        
        self.backgroundColor=[UIColor lightGrayColor];
        
        //self.alpha = 0.8;


        //收Menu 的 Button
        UIButton *MenuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        MenuButton.frame=CGRectMake(0,0, 44, 42);
        [MenuButton setImage:[UIImage imageNamed:@"清單48x48@2x.png"] forState:UIControlStateNormal];
        [MenuButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];//按下去時呼叫 callMenu 方法來收起 Menu
        [self addSubview:MenuButton];
        
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

-(void)detectPan:(UIPanGestureRecognizer*)recognizer {
   CGPoint translation =  [recognizer translationInView:self.superview];
    
    if(self.frame.origin.x > 0) {
        self.frame=CGRectMake(0,20,fullScreenBounds.size.width*self.MenuScreenScale,fullScreenBounds.size.height);
        
    }else if(self.frame.origin.x+translation.x < 0){
       self.frame=CGRectMake(lastLocation.x+translation.x,20,
                             fullScreenBounds.size.width*self.MenuScreenScale,
                             fullScreenBounds.size.height);
    }
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        if(self.frame.origin.x < -100 ) {
            [UIView beginAnimations:@"inMenu" context:nil];
            [UIView setAnimationDelegate:self];
            self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,20,
                                  fullScreenBounds.size.width*self.MenuScreenScale,
                                  fullScreenBounds.size.height);
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:@"inMenu" context:nil];
            [UIView setAnimationDelegate:self];
            self.frame=CGRectMake(0,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
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

-(void)addMenu{
    //        設定Table 代理人
    MenuTableView=[[UITableView alloc] init];
    MenuTableView.dataSource=self;
    MenuTableView.delegate=self;
    MenuTableView.frame=CGRectMake(0,70, self.frame.size.width, self.frame.size.height-44);
    MenuTableView.allowsSelection=YES;
    [self addSubview:MenuTableView];
    
}

-(void)callMenu{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image1"];
    UIImage *image = [UIImage imageWithData:imageData];
    if(image != nil){
        [ImageMenuArray addObject:image];
    }
    
    [MenuTableView reloadData];
    
    self.hidden = false;
//    CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];
    [UIView beginAnimations:@"inMenu" context:nil];
    [UIView setAnimationDuration:self.SwichingPageSpeed];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(SwichingPage)];
    
    if (self.frame.origin.x==-fullScreenBounds.size.width*self.MenuScreenScale) {
        self.frame=CGRectMake(0,20, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MenuArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *myCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Menu"];
    
    myCell.textLabel.text=[MenuArray objectAtIndex:indexPath.row];
    [myCell.textLabel setTextAlignment:NSTextAlignmentRight];
    
    if(ImageMenuArray.count != 0){
    myCell.imageView.image = [ImageMenuArray objectAtIndex:indexPath.row];
    myCell.imageView.layer.cornerRadius = 22;
    myCell.imageView.clipsToBounds = YES;
    myCell.imageView.layer.borderWidth = 2.0;
    myCell.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    myCell.imageView.layer.masksToBounds = YES;
    }
    return myCell;
}

#pragma mark -UITableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self callMenu];
    targetPageID=indexPath.row;//設定目標 tab ID
}




@end
