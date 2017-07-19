//
//  SliderMenuView.h
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SliderMenuViewLeft : UIView<UITableViewDelegate,UITableViewDataSource>



@property float MenuScreenScale;

@property float SwichingPageSpeed;

-(void)callMenu;


@end
