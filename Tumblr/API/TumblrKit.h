//
//  Tumblr.h
//  Tumblr
//
//  Created by Robert Dougan on 12/17/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#pragma mark - Keychain
static NSString *const kTKKeychainServiceName = @"Tumblr";

#pragma mark - API

static NSString *const kTKServiceName = @"Tumblr";
static NSString *const kTKClientID = @"gryG4pfeBDpg1XnZqlhXJGxKHzsH5bJTfCYOrHsXkHDhCMYhlC";
static NSString *const kTKClientSecret = @"7uWuLgFPxJc3RsAE1b8KQo63D4w7dWK6SV91Sb8thhpnBYj6l2";

static NSString *const kTKRequestURLString = @"http://www.tumblr.com/oauth/request_token";
static NSString *const kTKAccessURLString = @"http://www.tumblr.com/oauth/access_token";
static NSString *const kTKAuthroizeURLString = @"http://www.tumblr.com/oauth/authorize";

static NSString *const kTKBaseURLString = @"http://api.tumblr.com/";
static NSString *const kTKAPIVersion = @"v2";

#pragma mark - User Defaults
static NSString *const kTKDefaultPostBlogKey = @"kTKDefaultPostBlogKey";

#pragma mark - Notifications

static NSString *const kTKCurrentUserChangedNotificationName = @"kTKCurrentUserChangedNotificationName";
static NSString *const kTKCurrentDefaultPostBlogChangedNotificationName = @"kTKCurrentDefaultPostBlogChangedNotificationName";

#pragma mark - Post Types
typedef enum {
    TKPostTypeText     = 0,
    TKPostTypePhoto    = 1,
    TKPostTypePhotoSet = 2,
    TKPostTypeQuote    = 3,
    TKPostTypeLink     = 4,
    TKPostTypeChat     = 5,
    TKPostTypeAudio    = 6,
    TKPostTypeVideo    = 7,
    TKPostTypeAnswer   = 8
} TKPostType;

#pragma mark - Import

#import "TKHTTPClient.h"

// Categories
#import "NSNumber+TumblrKit.h"
#import "NSDictionary+TumblrKit.h"

// Models
#import "TKPhotoSize.h"
#import "TKPhoto.h"
#import "TKPhotoSet.h"
#import "TKChat.h"
#import "TKBlog.h"
#import "TKPost.h"
#import "TKUser.h"