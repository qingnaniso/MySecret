//
//  Photo.h
//  今天吃啥啊
//
//  Created by Qiqingnan on 14-6-23.
//  Copyright (c) 2014年 qiqingnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * flag;

@end
