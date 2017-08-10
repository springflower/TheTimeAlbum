//
//  SliderMenuLeftTableViewCell.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/10.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "SliderMenuLeftTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>

@implementation SliderMenuLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.layer.cornerRadius = 25;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.frame = CGRectMake(10,5,50,50);
    
    self.detailTextLabel.textColor = [UIColor flatGrayColor];
    [self.detailTextLabel sizeToFit];
}

@end
