//
//  Blog.h
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TKUser;
@class TKPost;

@interface TKBlog : SSRemoteManagedObject

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

@property (nonatomic, retain) TKUser *user;
@property (nonatomic, retain) TKUser *followedUser;

@property (nonatomic, retain) NSSet *posts;

- (NSString *)hostname;

+ (TKBlog *)defaultBlog;
+ (void)setDefaultBlog:(TKBlog *)defaultBlog;

@end

@interface TKBlog (CoreDataGeneratedAccessors)
- (void)addPostsObject:(TKPost *)value;
- (void)removePostsObject:(TKPost *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;
@end