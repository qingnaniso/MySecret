//
//  SecretPhotosLibViewController.m
//  SecretPhotosLib
//
//  Created by Qiqingnan on 14-6-17.
//  Copyright (c) 2014年 qiqingnan. All rights reserved.
//

#import "DoAlbumCell.h"
#import "DoImagePickerController.h"
#import "AssetHelper.h"

@implementation DoAlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated  //选中时的行为
{
    [super setSelected:selected animated:animated];

    if (selected)
    {
        _lbAlbumName.textColor  = [UIColor whiteColor];
        _lbCount.textColor      = [UIColor whiteColor];
        
        self.contentView.backgroundColor = DO_ALBUM_NAME_TEXT_COLOR;
    }
    else
    {
        _lbAlbumName.textColor  = DO_ALBUM_NAME_TEXT_COLOR;
        _lbCount.textColor      = DO_ALBUM_COUNT_TEXT_COLOR;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
