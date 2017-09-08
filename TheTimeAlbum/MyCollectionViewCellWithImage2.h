//
//  MyCollectionViewCellWithImage2.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/9/3.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCellWithImage2 : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *image01;
@property (weak, nonatomic) IBOutlet UIImageView *image02;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate2;
@property (weak, nonatomic) IBOutlet UILabel *labelSign;
@property (weak, nonatomic) IBOutlet UILabel *labelNumOfPhotos;

@end
