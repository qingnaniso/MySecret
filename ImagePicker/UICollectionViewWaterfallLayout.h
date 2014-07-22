//
//  UICollectionViewWaterfallLayout.h
//  私人相册
//
//  Created by Qiqingnan on 14-7-10.
//  Copyright (c) 2014年 qingnan qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewWaterfallLayout;
@protocol UICollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionViewWaterfallLayout : UICollectionViewLayout
@property (nonatomic, weak) id<UICollectionViewDelegateWaterfallLayout> delegate;
@property (nonatomic, assign) NSUInteger columnCount; // How many columns
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section
@end
