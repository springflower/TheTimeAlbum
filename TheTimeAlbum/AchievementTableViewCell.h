//
//  AchievementTableViewCell.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/7.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchievementTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *howManyDays;
@property (weak, nonatomic) IBOutlet UILabel *creatDate;
@property (weak, nonatomic) IBOutlet UIImageView *achievementPic;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPic;

@end
