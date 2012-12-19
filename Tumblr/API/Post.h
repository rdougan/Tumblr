//
//  Post.h
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Blog;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * blogName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * postURL;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * format;
@property (nonatomic, retain) NSString * reblogKey;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * sourceURL;
@property (nonatomic, retain) NSString * sourceTitle;
@property (nonatomic, retain) NSNumber * liked;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * totalPosts;
@property (nonatomic, retain) Blog *blog;

@end
