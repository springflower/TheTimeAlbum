//
//  SliderMenuView.h
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/17.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SliderMenuViewLeft : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property float MenuScreenScale;


-(void)callMenu;

-(void)detectPan:(UIPanGestureRecognizer*)recognizer;

@end
