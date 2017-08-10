//
//  TabBarController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/8.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "ColorTabBarView.h"
#import "TabBarController.h"
#import <ChameleonFramework/Chameleon.h>

#define SELF_WIDTH CGRectGetWidth(self.bounds)
#define SELF_HEIGHT CGRectGetHeight(self.bounds)

@interface TabBarController ()<UIGestureRecognizerDelegate>

@end

@implementation TabBarController
{
    NSInteger itemCout;
    NSInteger toIndex;
    NSInteger fromeIndex;
    UIView *colorfulView;
    UIView *colorfulMaskView;
    UITabBar *ColorTabBarView;
}


+(instancetype)object
{
    static TabBarController *testObject = nil;
    if(testObject == nil)
    {
        testObject = [[TabBarController alloc]init];
    }
    return testObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
//    ColorTabBarView *ColorTabBarView = [[ColorTabBarView alloc] initWithFrame:self.tabBar.frame];
//    [self setValue:tabBar forKey:@"tabBar"];
    
//    itemCout = 4;
    
//    [self setupColorView];
//    
//    [self setupMaskLayer];
//    
//    [self layoutSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"putAWayLeftMenu" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"putAwayRightMenu" object:nil];
    
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.2];
    [transition setType:kCATransitionFade];
    [self.view.layer addAnimation:transition forKey:nil];
    
    
//    NSInteger index = [self.tabBarController.tabBar.items indexOfObject:item];
//    fromeIndex = toIndex;
//    toIndex = index;
//    [self animation];
    
}

//- (void)setupMaskLayer {
//    
//    CGFloat itemWidth = self.tabBarController.tabBar.frame.size.width/itemCout;
//    
//    UIView *colorMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, self.tabBarController.tabBar.frame.size.height)];
//    colorMaskView.backgroundColor = [UIColor blackColor];
//    colorfulMaskView = colorMaskView;
//    colorfulView.layer.mask = colorfulMaskView.layer;
//    
//}
//
//-(void)setupColorView {
//    NSArray *itemColor = @[[UIColor blueColor],[UIColor redColor],[UIColor greenColor],[UIColor blackColor]];
//    itemCout = 4;
//    
//    UIView *colorView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    [ColorTabBarView addSubview:colorView];
//    colorfulView = colorView;
//    
//    CGFloat itemWidth = self.tabBarController.tabBar.frame.size.width / itemCout;
//    
//    for (int i = 0; i < itemCout;i++) {
//        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, self.tabBarController.tabBar.frame.size.height)];
//        view.backgroundColor = [UIColor flatSkyBlueColor];
//        [colorfulView addSubview:view];
//    }
//}
//
//
//- (void)animation {
//    
//    CGFloat itemWidth = self.tabBarController.tabBar.frame.size.width / itemCout;
//    // 遮罩每次移动时，都先会多出来一部分，然后再到另一个index，这个变量用来设置多出来那部分的宽度
//    CGFloat extraWidth = itemWidth / 4;
//    
//    // 根据多出来的部分，设置frame
//    CGRect scaleFrame = CGRectMake(CGRectGetMinX(self.tabBarController.tabBar.frame), 0, itemWidth + extraWidth, self.tabBarController.tabBar.frame.size.height);
//    // 根据toIndex，计算新的frame
//    CGRect toFrame = CGRectMake(toIndex * itemWidth, 0, itemWidth,
//                                self.tabBarController.tabBar.frame.size.height);
//    
//    // 判断遮罩层应该滑动的方向，来修改多出来部分的frame
//    if (fromeIndex > toIndex) {
//        
//        scaleFrame = CGRectMake(CGRectGetMinX(colorfulMaskView.frame) - extraWidth, 0, itemWidth + extraWidth, self.tabBarController.tabBar.frame.size.height);
//    }
//    
//    // 动画分为两部分
//    // 第一部分：遮罩先展开一部分
//    // 第二部分：位移并缩小回原来的大小
//    // 第一部分淡入，第二部分淡出
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        
//        colorfulMaskView.frame = scaleFrame;
//    } completion:^(BOOL finished) {
//        
//        if (finished) {
//            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                
//                colorfulMaskView.frame = toFrame;
//            } completion:NULL];
//        }
//    }];
//}
//
//
//// 在这个方法中进行遮罩层的布局，横竖屏切换都会调用，所以可以进行横竖屏适配
//- (void)layoutSubviews {
//    
//    CGFloat itemWidth = self.tabBarController.tabBar.frame.size.width / itemCout;
//    NSArray *subviews = colorfulView.subviews;
//    
//    colorfulMaskView.frame = CGRectMake(toIndex * itemWidth, 0, itemWidth, CGRectGetHeight(colorfulMaskView.frame));
//    
//    for (int i = 0; i < subviews.count; i ++) {
//        
//        UIView *view = subviews[i];
//        view.frame = CGRectMake(itemWidth * i, 0, itemWidth,
//                                self.tabBarController.tabBar.frame.size.height);
//    }
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
