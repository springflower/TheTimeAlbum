//
//  MYTextAttachment.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/1.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "MyTextAttachment.h"

@implementation MyTextAttachment


- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {

    CGFloat width = lineFrag.size.width-10;
    
    // Scale how you want
    float scalingFactor = 1.0;
    CGSize imageSize = [self.image size];
    if (width < imageSize.width)
        scalingFactor = width / imageSize.width;
    CGRect rect = CGRectMake(0, 0, imageSize.width * scalingFactor, imageSize.height * scalingFactor);
    
    return rect;
}


@end
