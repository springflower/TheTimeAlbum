//
//  MyCollectionViewCellWithImage1.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/1.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "MyCollectionViewCellWithImage1.h"
#import <Chameleon.h>

@implementation MyCollectionViewCellWithImage1

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellPic01.layer.borderWidth = 2;
    self.cellPic01.layer.borderColor = [UIColor flatCoffeeColorDark].CGColor;
    self.cellPic01.layer.cornerRadius = 5;
    self.cellPic01.clipsToBounds = YES;
    // Initialization code
}

@end
