//
//  textLayout.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/24.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "textLayout.h"


@implementation textLayout

- (void)prepareLayout
{
    // 必须要调用父类(父类也有一些准备操作)
    [super prepareLayout];
    
    // 设置滚动方向(只有流水布局才有这个属性)
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置cell的大小
    //CGFloat itemWH = self.collectionView.frame.size.height * 0.8;
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width-10, 150);
    
    // 设置内边距
    //CGFloat inset = (self.collectionView.frame.size.width - itemWH) * 0.5;
  //  self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}








// 設定到哪個位置取哪個元素的陣列
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:path];
        [array addObject:attrs];
    }
    
    return array;
}

// 設定每個 cell 的屬性如大小 位置
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attrs.center = CGPointMake(self.collectionView.frame.size.width * 0.5, (self.collectionView.frame.size.height * 0.19) + 150*indexPath.item);
    attrs.size = CGSizeMake(self.collectionView.bounds.size.width-10, 150);
    attrs.zIndex = - indexPath.item;
    
    
    return attrs;
}
@end
