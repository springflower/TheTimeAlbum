//
//  MyCollectionViewCellWithText.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/24.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCellWithText : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelSign;
@property (weak, nonatomic) IBOutlet UITextView *detalText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
