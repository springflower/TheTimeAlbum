//
//  ViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/10.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "ViewController.h"
#import "SliderMenuViewLeft.h"
#import "AddChildSettingViewController.h"
@interface ViewController()
{
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"相簿";
    [self SettingSilderMenuViewAndButtonItemToNavigationBar];
    
    // Prepare the NorificationCenter change ViewConroller to AddChildSettingViewController.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewContrllerToAddChildSettingViewController) name:@"settingChild" object:nil];
    
    
}

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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                  UIBarButtonSystemItemSearch target:self action:@selector(callMenuRight)];
    addButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *messageButton = [UIBarButtonItem new];
    [messageButton setImage:[UIImage imageNamed:@"icon_message48x48.png"]];
    messageButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:addButton,messageButton, nil];
    
    UIBarButtonItem *listButton = [UIBarButtonItem new];
    [listButton setAction:@selector(callMenuLeft)];
    [listButton setTarget:self];
    [listButton setImage:[UIImage imageNamed:@"清單30x30@2x.png"]];
    listButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = listButton;
    
    // Setting the NaviagtionBar BackGroundColor to CleanColor.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
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


//-(void)passValue:(NSNumber*)nextPage {
//    NSLog(@"aa");
//    if([nextPage  isEqual: @1]) {
//        NSLog(@"我有執行");
//        [self nextPage];
//    }
//}

@end
