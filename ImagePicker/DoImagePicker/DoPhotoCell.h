//
//  SecretPhotosLibViewController.m
//  SecretPhotosLib
//
//  Created by Qiqingnan on 14-6-17.
//  Copyright (c) 2014年 qiqingnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *ivPhoto;
@property (weak, nonatomic) IBOutlet UIView         *vSelect;

- (void)setSelectMode:(BOOL)bSelect;

@end
