//
//  JLNavigationViewController.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/31.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "JLNavigationViewController.h"

@interface JLNavigationViewController ()

@end

@implementation JLNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
