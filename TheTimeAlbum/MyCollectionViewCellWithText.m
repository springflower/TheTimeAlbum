//
//  MyCollectionViewCellWithText.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/24.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "MyCollectionViewCellWithText.h"
@interface MyCollectionViewCellWithText()



@end

@implementation MyCollectionViewCellWithText

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.layer.borderWidth = 5;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.clipsToBounds = YES;
    // Initialization code
}

@end
