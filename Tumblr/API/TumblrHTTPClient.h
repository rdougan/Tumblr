//
//  TumblrHTTPClient.h
//  Tumblr
//
//  Created by Robert Dougan on 12/16/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

typedef void (^TumblrHTTPClientSuccess)(AFJSONRequestOperation *operation, id responseObject);
typedef void (^TumblrHTTPClientFailure)(AFJSONRequestOperation *operation, NSError *error);

@class User;
@class Blog;
@class Post;

@class GTMOAuthAuthentication;

@interface TumblrHTTPClient : AFHTTPClient {
    
}

+ (TumblrHTTPClient *)sharedClient;

#pragma mark - Authentication

- (BOOL)isLoggedIn;
- (void)login;
- (void)logout;

#pragma mark - Users

- (void)updateUserInfo:(User *)user success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;
- (void)dashboardForUser:(User *)user success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;
- (void)dashboardForUser:(User *)user offset:(int)offset success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;

#pragma mark - Blogs

- (void)postsForBlog:(Blog *)blog success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;
- (void)postsForBlog:(Blog *)blog offset:(int)offset success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;

- (void)savePost:(Post *)post forBlog:(Blog *)blog success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure;

@end
