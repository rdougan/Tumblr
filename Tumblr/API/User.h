//
//  User.h
//  Tumblr
//
//  Created by Robert Dougan on 12/17/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface User : SSRemoteManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *following;
@property (nonatomic, retain) NSNumber *likes;
@property (nonatomic, retain) NSString *defaultPostFormat;
@property (nonatomic, retain) NSSet *blogs;
@property (nonatomic, retain) NSSet *posts;

@property (nonatomic, strong) NSString *accessToken;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

- (void)updateInfoWithSuccess:(void(^)(void))success failure:(void(^)(void))failure;

@end

@interface User (CoreDataGeneratedAccessors)
- (void)addBlogsObject:(Blog *)value;
- (void)removeBlogsObject:(Blog *)value;
- (void)addBlogs:(NSSet *)values;
- (void)removeBlogs:(NSSet *)values;
@end
