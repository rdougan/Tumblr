//
//  User.m
//  Tumblr
//
//  Created by Robert Dougan on 12/17/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "User.h"

static NSString *const kCDKUserIDKey = @"CDKUserID";
static User *__currentUser = nil;

@implementation User

@dynamic following;
@dynamic likes;
@dynamic name;
@dynamic defaultPostFormat;
@dynamic blogs;
@dynamic posts;
@synthesize accessToken = _accessToken;

+ (NSString *)entityName {
	return @"User";
}

+ (User *)currentUser {
	if (!__currentUser) {
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSString *userID = [userDefaults objectForKey:kCDKUserIDKey];
		if (!userID) {
			return nil;
		}
		
		NSString *accessToken = [SSKeychain passwordForService:kTumblrKeychainServiceName account:userID.description];
		if (!accessToken) {
			return nil;
		}
        
		__currentUser = [self existingObjectWithRemoteID:userID];
		__currentUser.accessToken = accessToken;
	}
	return __currentUser;
}


+ (void)setCurrentUser:(User *)user {
	if (__currentUser) {
		[SSKeychain deletePasswordForService:kTumblrKeychainServiceName account:__currentUser.remoteID.description];
	}
	
	if (!user.remoteID || !user.accessToken) {
        if (__currentUser) {
            [__currentUser delete];
        }
		__currentUser = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kTumblrCurrentUserChangedNotificationName object:nil];
		return;
	}
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:user.remoteID forKey:kCDKUserIDKey];
	[userDefaults synchronize];
	
	[SSKeychain setPassword:user.accessToken forService:kTumblrKeychainServiceName account:user.remoteID.description];
	
	__currentUser = user;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kTumblrCurrentUserChangedNotificationName object:user];
}

- (void)unpackDictionary:(NSDictionary *)dictionary {
	[super unpackDictionary:dictionary];
    
	self.name = [dictionary safeObjectForKey:@"name"];
	self.likes = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"likes"] intValue]];
	self.following = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"following"] intValue]];
    
    // Delete all existing blogs
    [self.blogs makeObjectsPerformSelector:@selector(delete)];
    
    for (NSDictionary *blogDictionary in [dictionary objectForKey:@"blogs"]) {
		Blog *blog = [Blog objectWithDictionary:blogDictionary context:self.managedObjectContext];
		blog.user = self;
	}
}

#pragma mark - API

- (void)updateInfoWithSuccess:(void(^)(void))success failure:(void(^)(void))failure
{
    [[TumblrHTTPClient sharedClient] updateUserInfo:self success:^(AFJSONRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

@end
