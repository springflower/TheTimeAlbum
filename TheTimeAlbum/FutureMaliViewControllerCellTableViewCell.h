//
//  FutureMaliViewControllerCellTableViewCell.h
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/28.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FutureMaliViewControllerCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *MyCell;

@property (weak, nonatomic) IBOutlet UIImageView*MyImageView;

@property (weak, nonatomic) IBOutlet UILabel *DateAndTime;

@property (weak, nonatomic) IBOutlet UILabel *UserName;

@property (weak, nonatomic) IBOutlet UILabel *ChildName;


@end
