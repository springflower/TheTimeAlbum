//
//  MyCollectionViewCellUploading.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/28.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "MyCollectionViewCellUploading.h"
#import <Chameleon.h>

@implementation MyCollectionViewCellUploading

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    
//    
//    
//    
    self.maskUIView.layer.borderWidth = 2;
//    self.maskUIView.layer.borderColor = [UIColor flatCoffeeColorDark].CGColor;
    self.maskUIView.layer.cornerRadius = 5;
    self.maskUIView.clipsToBounds = YES;
    //self.maskUIView.alpha = 0;
    
    self.backgroundImageView.layer.borderWidth = 2;
    self.backgroundImageView.layer.borderColor = [UIColor flatCoffeeColorDark].CGColor;
    self.backgroundImageView.layer.cornerRadius = 5;
    self.backgroundImageView.clipsToBounds = YES;
    
    
}

@end
