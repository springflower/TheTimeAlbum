//
//  MyCollectionViewCellWithImage2.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/9/3.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "MyCollectionViewCellWithImage2.h"
#import <Chameleon.h>

@implementation MyCollectionViewCellWithImage2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.image01.contentMode = UIViewContentModeScaleAspectFill;
    self.image01.clipsToBounds =YES;
    
    self.image02.contentMode = UIViewContentModeScaleAspectFill;
    self.image02.clipsToBounds =YES;
    
    self.backGroundImage.layer.borderWidth = 1;
    //self.backGroundImage.layer.borderColor = [UIColor flatGrayColor].CGColor;
    self.layer.borderColor = [UIColor flatCoffeeColor].CGColor;
    self.backGroundImage.layer.cornerRadius = 5;
    self.backGroundImage.clipsToBounds = YES;
    
}

@end
