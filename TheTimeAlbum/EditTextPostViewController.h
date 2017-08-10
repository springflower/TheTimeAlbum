//
//  EditTextPostViewController.h
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/8/7.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostItem.h"

@interface EditTextPostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property NSInteger postID;

@property (weak, nonatomic) NSMutableArray *PostItems;
@property (weak, nonatomic) NSString *titleString;
@property (weak, nonatomic) NSString *contentString;

@end
