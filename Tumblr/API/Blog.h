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
@class Post;

@interface Blog : SSRemoteManagedObject

@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSNumber *postsCount;
@property (nonatomic, retain) NSNumber *drafts;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *queue;
@property (nonatomic, retain) NSNumber *primary;
@property (nonatomic, retain) NSNumber *ask;
@property (nonatomic, retain) NSNumber *askAnon;
@property (nonatomic, retain) NSNumber *admin;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *posts;

- (NSString *)hostname;

@end

@interface Blog (CoreDataGeneratedAccessors)
- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;
@end