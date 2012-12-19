//
//  TumblrHTTPClient.h
//  Tumblr
//
//  Created by Robert Dougan on 12/16/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

typedef void (^TumblrHTTPClientSuccess)(AFJSONRequestOperation *operation, id responseObject);
typedef void (^TumblrHTTPClientFailure)(AFJSONRequestOperation *operation, NSError *error);

@class TKUser;
@class TKBlog;
@class TKPost;

@class GTMOAuthAuthentication;

@interface TKHTTPClient : AFHTTPClient {
    
}

+ (TKHTTPClient *)sharedClient;

#pragma mark - Authentication

- (BOOL)isLoggedIn;
- (void)login;
- (void)logout;

#pragma mark - Users

- (void)updateUserInfo:(TKUser *)user success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;
- (void)dashboardForUser:(TKUser *)user success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;
- (void)dashboardForUser:(TKUser *)user offset:(int)offset success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;

#pragma mark - Blogs

- (void)postsForBlog:(TKBlog *)blog success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;
- (void)postsForBlog:(TKBlog *)blog offset:(int)offset success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;

- (void)savePost:(TKPost *)post forBlog:(TKBlog *)blog success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;

@end
