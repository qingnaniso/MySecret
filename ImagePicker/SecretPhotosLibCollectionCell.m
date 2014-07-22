//
//  SecretPhotosLibCollectionCell.m
//  私人相册
//
//  Created by Qiqingnan on 14-7-17.
//  Copyright (c) 2014年 qingnan qi. All rights reserved.
//

#import "SecretPhotosLibCollectionCell.h"

@implementation SecretPhotosLibCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)deletePic:(id)sender {
    // find my collection view
    UIView* v = self;
    do {
        v = v.superview;
    } while (![v isKindOfClass:[UICollectionView class]]);
    UICollectionView* cv = (UICollectionView*) v;
    // ask it what index path we are
    NSIndexPath* ip = [cv indexPathForCell:self];
    // talk to its delegate
    if (cv.delegate &&
        [cv.delegate respondsToSelector:
         @selector(collectionView:performAction:forItemAtIndexPath:withSender:)])
        [cv.delegate collectionView:cv performAction:_cmd
                 forItemAtIndexPath:ip withSender:sender];
    //_cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例一样。
}
-(void)share:(id)sender {
    // find my collection view
    UIView* v = self;
    do {
        v = v.superview;
    } while (![v isKindOfClass:[UICollectionView class]]);
    UICollectionView* cv = (UICollectionView*) v;
    // ask it what index path we are
    NSIndexPath* ip = [cv indexPathForCell:self];
    // talk to its delegate
    if (cv.delegate &&
        [cv.delegate respondsToSelector:
         @selector(collectionView:performAction:forItemAtIndexPath:withSender:)])
        [cv.delegate collectionView:cv performAction:_cmd
                 forItemAtIndexPath:ip withSender:sender];
    //_cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例一样。
}

@end
