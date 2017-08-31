//
//  MYTextAttachment.h
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/1.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextAttachment : NSTextAttachment


- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex ;

@end
