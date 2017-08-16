//
//  SelectedRow.h
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/8/5.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedRow : NSObject {
    
@private

    int SelectRow;
    BOOL Value;
}

+(instancetype) object;

-(void)SendSelectedRowAboutMail:(int)selected Bool:(BOOL)value;

- (int)didSelectedRowAboutMail;

- (BOOL)didSelectedNewOrOldAboutMail;

@end
