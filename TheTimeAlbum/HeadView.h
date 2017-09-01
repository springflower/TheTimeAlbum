//
//  HeadView.h
//  
//
//  Created by 林子涵 on 2017/7/23.
//
//

#import <UIKit/UIKit.h>

@interface HeadView:UIView
@property (weak, nonatomic) UIImageView * backgroundView;
@property (weak, nonatomic) UIImageView * headView;
@property (weak, nonatomic) UILabel * signLabel;
@property (strong, nonatomic) UIView * maskView;
- (instancetype)initWithFrame:(CGRect)frame backgroundView:(NSString *)name headView:(NSString *)headImgName headViewWidth:(CGFloat)width signLabel:(NSString *)signature;

- (instancetype)initWithFrameByBryan:(CGRect)frame backgroundView:(UIImage *)name headView:(UIImage *)headImgName headViewWidth:(CGFloat)width signLabel:(NSString *)signature;
@end
