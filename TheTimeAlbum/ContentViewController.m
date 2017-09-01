//
//  ContentViewController.m
//  HelloPageViewController
//
//  Created by TsaiHsueh Hsin on 2015/11/20.
//  Copyright © 2015年 Glee. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;


@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.backgroundImageView.image = self.backgroundImage;
    // 將字串轉網址物件
    NSURL * imageLoc = [NSURL URLWithString:self.imageURL];
    
    // 開執行緒，並執行 block 中的內容
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 下載網址物件的內容
        NSData * imageData = [[NSData alloc] initWithContentsOfURL:imageLoc];
        // 將下載到的內容轉成圖片
        UIImage * image = [UIImage imageWithData:imageData];
        // 切回主執行緒
        dispatch_async(dispatch_get_main_queue(), ^{
            // 設定背景圖
            self.backGroundImageView.image = image;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
