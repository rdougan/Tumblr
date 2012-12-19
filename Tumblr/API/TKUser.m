//
//  User.m
//  Tumblr
//
//  Created by Robert Dougan on 12/17/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TKUser.h"

static NSString *const kTKUserIDKey = @"TKUserID";
static TKUser *__currentUser = nil;

@implementation TKUser

@dynamic followingCount;
@dynamic likesCount;
@dynamic name;
@dynamic defaultPostFormat;

@dynamic blogs;
@dynamic posts;
@dynamic dashboard;
@dynamic likes;
@dynamic following;

@synthesize accessToken = _accessToken;

+ (NSString *)entityName {
	return @"TKUser";
}

+ (TKUser *)currentUser {
	if (!__currentUser) {
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSString *userID = [userDefaults objectForKey:kTKUserIDKey];
		if (!userID) {
			return nil;
		}
		
		NSString *accessToken = [SSKeychain passwordForService:kTKKeychainServiceName account:userID.description];
		if (!accessToken) {
			return nil;
		}
        
		__currentUser = [self existingObjectWithRemoteID:userID];
		__currentUser.accessToken = accessToken;
	}
	return __currentUser;
}

+ (void)setCurrentUser:(TKUser *)user {
	if (__currentUser) {
		[SSKeychain deletePasswordForService:kTKKeychainServiceName account:__currentUser.remoteID.description];
	}
	
	if (!user.remoteID || !user.accessToken) {
        if (__currentUser) {
            [__currentUser delete];
        }
		__currentUser = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kTKCurrentUserChangedNotificationName object:nil];
		return;
	}
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:user.remoteID forKey:kTKUserIDKey];
	[userDefaults synchronize];
	
	[SSKeychain setPassword:user.accessToken forService:kTKKeychainServiceName account:user.remoteID.description];
	
	__currentUser = user;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kTKCurrentUserChangedNotificationName object:user];
}

- (void)unpackDictionary:(NSDictionary *)dictionary {
	[super unpackDictionary:dictionary];
    
	self.name = [dictionary safeObjectForKey:@"name"];
	self.likesCount = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"likes"] intValue]];
	self.followingCount = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"following"] intValue]];
    
    // Delete all existing blogs
    [self.blogs makeObjectsPerformSelector:@selector(delete)];
    
    for (NSDictionary *blogDictionary in [dictionary objectForKey:@"blogs"]) {
		TKBlog *blog = [TKBlog objectWithDictionary:blogDictionary context:self.managedObjectContext];
		blog.user = self;
	}
}

#pragma mark - API

- (void)updateInfoWithSuccess:(void(^)(void))success failure:(void(^)(void))failure
{
    [[TKHTTPClient sharedClient] updateUserInfo:self success:^(AFJSONRequestOperation *operation, id responseObject) {
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
