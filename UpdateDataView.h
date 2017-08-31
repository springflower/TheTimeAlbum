//
//  UpdateDataView.h
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/20.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassValueBlock)(NSArray*);

@interface UpdateDataView : UIView

-(void)DowloadChildBigSticker:(PassValueBlock)Array;

-(void)UpdataChildBigsticker:(NSArray*)Array;

-(void)UpdataChildBigstickerIfUseChangeunction:(NSArray*)Array;

-(void)UpdataChildBigstickerIfUseDeleteFunction:(NSArray*)Array;

@end
