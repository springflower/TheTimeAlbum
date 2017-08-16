//
//  AboutMeViewcontrollerCell.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "AboutMeViewcontrollerCell.h"

@implementation AboutMeViewcontrollerCell

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
    
    self.imageView.frame = CGRectMake(15,7,65,65);
}



@end
