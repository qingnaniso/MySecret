//
//  SecretPhotosLibViewController.m
//  SecretPhotosLib
//
//  Created by Qiqingnan on 14-6-17.
//  Copyright (c) 2014年 qiqingnan. All rights reserved.
//

#import "DoPhotoCell.h"

@implementation DoPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelectMode:(BOOL)bSelect
{
    if (bSelect)
        _ivPhoto.alpha = 0.2;
    else
        _ivPhoto.alpha = 1.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
