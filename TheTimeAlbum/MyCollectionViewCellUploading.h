//
//  MyCollectionViewCellUploading.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/28.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCellUploading : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *maskUIView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
