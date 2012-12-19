//
//  User.h
//  Tumblr
//
//  Created by Robert Dougan on 12/17/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * defaultPostFormat;
@property (nonatomic, retain) NSManagedObject *blogs;

@end
