//
//  HeadView.m
//  
//
//  Created by 林子涵 on 2017/7/23.
//
//

#import "HeadView.h"
#import <UIKit/UIKit.h>
#import "myDefines.h"


@implementation HeadView
- (instancetype)initWithFrame:(CGRect)frame backgroundView:(NSString *)name headView:(NSString *)headImgName headViewWidth:(CGFloat)width signLabel:(NSString *)signature
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -navHeight, frame.size.width, frame.size.height)];
        UIImage * image = [UIImage imageNamed:name];
        UIImage * newImg = [self image:image byScalingToSize:self.bounds.size];
        backgroundView.image = newImg;
        backgroundView.clipsToBounds = YES;
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
        
        UIImageView * headView = [[UIImageView alloc]initWithFrame:(CGRect){(frame.size.width - width) * 0.5,0.5 * (frame.size.height - width) - navHeight,width,width}];
        headView.layer.cornerRadius = width*0.5;
        headView.layer.masksToBounds = YES;
        headView.image = [UIImage imageNamed:headImgName];
        [self addSubview:headView];
        _headView = headView;
        
        UILabel * signLabel = [[UILabel alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(headView.frame) ,self.bounds.size.width,120}];
        signLabel.text = signature;
        signLabel.textAlignment = NSTextAlignmentCenter;
        signLabel.textColor = [UIColor whiteColor];
        [self addSubview:signLabel];
        _signLabel = signLabel;
        
    }
    return self;
}


- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

@end
