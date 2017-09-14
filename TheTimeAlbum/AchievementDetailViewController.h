//
//  AchievementDetailViewController.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/9/14.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "ViewController.h"
#import "achievementItem.h"

@interface AchievementDetailViewController : ViewController

@property (nonatomic, strong) NSMutableArray * thisAchievementItems;
@property (nonatomic, strong) achievementItem *thisAchievementItem;
@property (weak, nonatomic) IBOutlet UIImageView *achievementIconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;


@end
