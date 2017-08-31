//
//  StartCreateFirstChildViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/26.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "StartCreateFirstChildViewController.h"

@interface StartCreateFirstChildViewController ()

@end

@implementation StartCreateFirstChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //通知執行 saveChildNameAndBirthday 儲存資料
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dimissThisPage) name:@"DimissStartCreateFirstChildViewController" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dimissThisPage {
    
    [self dismissViewControllerAnimated:true completion:nil];
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
