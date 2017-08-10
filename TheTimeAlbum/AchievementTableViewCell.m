//
//  AchievementTableViewCell.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/7.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "AchievementTableViewCell.h"
#import <Chameleon.h>

@implementation AchievementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundPic.layer.borderWidth = 2;
    self.backgroundPic.layer.borderColor = [UIColor flatCoffeeColorDark].CGColor;
    self.backgroundPic.layer.cornerRadius = 5;
    self.backgroundPic.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = 8;
    //frame.origin.y = 2;
    frame.size.width  -= 2*frame.origin.x;
    frame.size.height -= 2*frame.origin.x;
    
    [super setFrame:frame];
}

@end
