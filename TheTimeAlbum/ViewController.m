//
//  ViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/10.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "ViewController.h"
#import <ChameleonFramework/Chameleon.h>

@interface ViewController ()
{
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatGreenColorDark];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.MenuLeft=[[SliderMenuViewLeft alloc] init];
    [self.view addSubview:self.MenuLeft];
    
    self.MenuRight=[[SliderMenuViewRight alloc] init];
    [self.view addSubview:self.MenuRight];
    
    self.navigationItem.title = @"Bryan";
    ////

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
    [addButton setAction:@selector(callMenuRight)];
    [addButton setTarget:self];
    addButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *messageButton = [UIBarButtonItem new];
    [messageButton setImage:[UIImage imageNamed:@"icon_message48x48.png"]];
    messageButton.tintColor = [UIColor whiteColor];
    
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:addButton,messageButton, nil];

  
    UIBarButtonItem *listButton = [UIBarButtonItem new];
    [listButton setAction:@selector(callMenuLeft)];
    [listButton setTarget:self];
    [listButton setImage:[UIImage imageNamed:@"清單30x30@2x.png"]];
    listButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = listButton;
 
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

//    [MenuButtonaddTarget:selfaction:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
//    [self.viewaddSubview:MenuButton];

    
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    //    不顯示 navigation Bar
//    self.navigationController.navigationBarHidden=YES;
//}
//
//
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    
//    //    必要時下一層顯示 navigation Bar
//    self.navigationController.navigationBarHidden=NO;
//}

-(void)callMenuLeft{
    //    呼叫目錄選單出現
    [self.MenuLeft callMenu];
    
}
-(void)callMenuRight{
    //    呼叫目錄選單出現
    [self.MenuRight callMenu];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupNavigationItem {
    
}


@end
