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
    
    self.backGroundImage.layer.borderWidth = 1;
    //self.backGroundImage.layer.borderColor = [UIColor flatGrayColor].CGColor;
    self.backGroundImage.layer.borderColor = [UIColor flatCoffeeColor].CGColor;
    self.backGroundImage.layer.cornerRadius = 5;
    self.backGroundImage.clipsToBounds = YES;
    
    self.image01.contentMode = UIViewContentModeScaleAspectFill;
    self.image01.clipsToBounds =YES;
}

@end
