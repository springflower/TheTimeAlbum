//
//  ColorTabBarView.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/9.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "ColorTabBarView.h"
#import "TabBarController.h"
#import <ChameleonFramework/Chameleon.h>

#define SELF_WIDTH CGRectGetWidth(self.bounds)
#define SELF_HEIGHT CGRectGetHeight(self.bounds)

@interface ColorTabBarView()<UITabBarDelegate>

@property(weak, nonatomic) UIView *colorfulView;

@property (strong, nonatomic) UIView *colorfulMaskView;

@property (assign, nonatomic) NSInteger fromeIndex;

@property (assign, nonatomic) NSInteger toIndex;

@end

@implementation ColorTabBarView
{
    NSInteger itemCount;
    TabBarController *tabBarController;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupColorView];
        
        [self setupMaskLayer];
    }
    
    return self;
}

- (void)setupMaskLayer {
    
    CGFloat itemWidth = SELF_WIDTH/itemCount;
    
    UIView *colorMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, SELF_HEIGHT)];
    colorMaskView.backgroundColor = [UIColor blackColor];
    self.colorfulMaskView = colorMaskView;
    self.colorfulView.layer.mask = self.colorfulMaskView.layer;

}

-(void)setupColorView {
    NSArray *itemColor = @[[UIColor blueColor],[UIColor redColor],[UIColor greenColor],[UIColor blackColor]];
    itemCount = 4;
    
    UIView *colorView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:colorView];

    self.colorfulView = colorView;
    
    CGFloat itemWidth = SELF_WIDTH / itemCount;
                          
    for (int i = 0; i < itemCount;i++) {
                              
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, SELF_HEIGHT)];
        view.backgroundColor = [UIColor flatSkyBlueColor];
        [self.colorfulView addSubview:view];
    }
}

// 动画
- (void)animation {
    
    CGFloat itemWidth = SELF_WIDTH / itemCount;
    // 遮罩每次移动时，都先会多出来一部分，然后再到另一个index，这个变量用来设置多出来那部分的宽度
    CGFloat extraWidth = itemWidth / 4;
    
    // 根据多出来的部分，设置frame
    CGRect scaleFrame = CGRectMake(CGRectGetMinX(self.colorfulMaskView.frame), 0, itemWidth + extraWidth, SELF_HEIGHT);
    // 根据toIndex，计算新的frame
    CGRect toFrame = CGRectMake(self.toIndex * itemWidth, 0, itemWidth, SELF_HEIGHT);
    
    // 判断遮罩层应该滑动的方向，来修改多出来部分的frame
    if (self.fromeIndex > self.toIndex) {
        
        scaleFrame = CGRectMake(CGRectGetMinX(self.colorfulMaskView.frame) - extraWidth, 0, itemWidth + extraWidth, SELF_HEIGHT);
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.colorfulMaskView.frame = scaleFrame;
    } completion:^(BOOL finished) {
        
        if (finished) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.colorfulMaskView.frame = toFrame;
            } completion:NULL];
        }
    }];
}


# pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    //準備發送通知收起左側選單
    [[NSNotificationCenter defaultCenter] postNotificationName:@"putAWayLeftMenu" object:nil];
    //準備發送通知收起右側選單
    [[NSNotificationCenter defaultCenter] postNotificationName:@"putAwayRightMenu" object:nil];
    //準備發送通知執行切換 TabBarControler 動畫
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarControlerAnimated" object:nil];
    //準備發送通知 PopSetInfoTableViewControler 結束
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopSetInfoTableViewControler" object:nil];
    //當 item 被選擇時，改變點選的 item 顏色
    self.tintColor = [UIColor flatWhiteColor];
    
    NSInteger index = [self.items indexOfObject:item];
    self.fromeIndex = self.toIndex;
    self.toIndex = index;
    [self animation];
    
    
    
}

// 因为tabbar设置代理先后顺序的原因，如果在初始化时，就将代理设置为自己，系统会在添加到UITabbarController上的时候，将代理设置为UITabbarController。
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.delegate = self;
}

// 在这个方法中进行遮罩层的布局，横竖屏切换都会调用，所以可以进行横竖屏适配
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat itemWidth = SELF_WIDTH / itemCount;
    NSArray *subviews = self.colorfulView.subviews;
    
    self.colorfulMaskView.frame = CGRectMake(self.toIndex * itemWidth, 0, itemWidth, CGRectGetHeight(self.colorfulMaskView.frame));
    
    for (int i = 0; i < subviews.count; i ++) {
        
        UIView *view = subviews[i];
        view.frame = CGRectMake(itemWidth * i, 0, itemWidth, SELF_HEIGHT);
    }
}


@end
