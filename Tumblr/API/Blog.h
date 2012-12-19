//
//  Blog.h
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Blog : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * posts;
@property (nonatomic, retain) NSNumber * drafts;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * queue;
@property (nonatomic, retain) NSNumber * primary;
@property (nonatomic, retain) NSNumber * ask;
@property (nonatomic, retain) NSNumber * ask_anon;
@property (nonatomic, retain) NSNumber * admin;
@property (nonatomic, retain) User *user;

@end
