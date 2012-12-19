//
//  Tumblr.h
//  Tumblr
//
//  Created by Robert Dougan on 12/17/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "NSDictionary+CheddarKit.h"

#pragma mark - Keychain
static NSString * const kTumblrKeychainServiceName = @"Tumblr";

#pragma mark - API

static NSString * const kTumbrServiceName = @"Tumblr";
static NSString * const kTumblrClientID = @"gryG4pfeBDpg1XnZqlhXJGxKHzsH5bJTfCYOrHsXkHDhCMYhlC";
static NSString * const kTumblrClientSecret = @"7uWuLgFPxJc3RsAE1b8KQo63D4w7dWK6SV91Sb8thhpnBYj6l2";

static NSString * const kTumblrRequestURLString = @"http://www.tumblr.com/oauth/request_token";
static NSString * const kTumblrAccessURLString = @"http://www.tumblr.com/oauth/access_token";
static NSString * const kTumblrAuthroizeURLString = @"http://www.tumblr.com/oauth/authorize";

static NSString * const kTumblrBaseURLString = @"http://api.tumblr.com/";
static NSString * const kTumblrAPIVersion = @"v2";

#pragma mark - Notifications

static NSString *const kTumblrCurrentUserChangedNotificationName = @"TumblrCurrentUserChangedNotification";

#pragma mark - Post Types
typedef enum {
    TumblrPostTypeText     = 0,
    TumblrPostTypePhoto    = 1,
    TumblrPostTypePhotoSet = 2,
    TumblrPostTypeQuote    = 3,
    TumblrPostTypeLink     = 4,
    TumblrPostTypeChat     = 5,
    TumblrPostTypeAudio    = 6,
    TumblrPostTypeVideo    = 7,
    TumblrPostTypeAnswer   = 8
} TumblrPostType;

#pragma mark - Import

#import "TumblrHTTPClient.h"

#import "NSNumber+PostType.h"

#import "Blog.h"
#import "Post.h"
#import "User.h"