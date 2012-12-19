//
//  TumblrHTTPClient.m
//  Tumblr
//
//  Created by Robert Dougan on 12/16/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrHTTPClient.h"

#import "AppDelegate.h"

#import "GTMOAuthAuthentication.h"
#import "GTMOAuthViewControllerTouch.h"
#import "SSKeyChain.h"

@interface TumblrHTTPClient ()
@property (nonatomic, retain) GTMOAuthAuthentication *auth;
@end

@implementation TumblrHTTPClient

#pragma mark - Singleton

+ (TumblrHTTPClient *)sharedClient
{
	static TumblrHTTPClient *sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedClient = [[self alloc] init];
	});
	return sharedClient;
}

#pragma mark - NSObject

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", kTumblrBaseURLString, kTumblrAPIVersion]]];
    if (self) {
        GTMOAuthAuthentication *auth = [self tumblrAuth];
        if (auth) {
            [GTMOAuthViewControllerTouch authorizeFromKeychainForName:kTumbrServiceName authentication:auth];
        }
        [self setAuth:auth];
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
		[self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

#pragma mark - GTMOAuthViewControllerTouch

- (GTMOAuthAuthentication *)tumblrAuth
{
    
    GTMOAuthAuthentication *auth;
    auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                       consumerKey:kTumblrClientID
                                                        privateKey:kTumblrClientSecret];
    
    [auth setServiceProvider:kTumbrServiceName];
    [auth setCallback:@"http://www.example.com/OAuthCallback"];
    
    return auth;
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error
{
    if (error != nil) {
        NSLog(@"error: %@", error);
    } else {
        [self setAuth:auth];
    }
    
    // Hide the modal window
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] navigationController] dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    // Get the user information
    [self getPath:@"user/info" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __weak NSManagedObjectContext *context = [User mainContext];
        [context performBlockAndWait:^{
            NSDictionary *dictionary = [responseObject valueForKeyPath:@"response.user"];
            User *user = [User objectWithDictionary:dictionary];
            user.accessToken = [auth privateKey];
            [user save];
            
            [User setCurrentUser:user];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - AFHTTPClient

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    // Add api_key
    NSMutableDictionary *params;
    if (parameters) {
        params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    } else {
        params = [NSMutableDictionary dictionary];
    }
    [params setObject:kTumblrClientID forKey:@"api_key"];
    
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:params];
    
    // Authorize equest with OAuth
    [_auth authorizeRequest:request];
    
    return request;
}

#pragma mark - Authentication

- (void)login
{
    GTMOAuthAuthentication *auth = [self tumblrAuth];
    
    // Display the autentication view
    GTMOAuthViewControllerTouch *viewController;
    viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:nil
                                                               language:nil
                                                        requestTokenURL:[NSURL URLWithString:kTumblrRequestURLString]
                                                      authorizeTokenURL:[NSURL URLWithString:kTumblrAuthroizeURLString]
                                                         accessTokenURL:[NSURL URLWithString:kTumblrAccessURLString]
                                                         authentication:auth
                                                         appServiceName:kTumbrServiceName
                                                               delegate:self
                                                       finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [viewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] navigationController] presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)logout
{
    [GTMOAuthViewControllerTouch removeParamsFromKeychainForName:kTumbrServiceName];
    [self setAuth:nil];
    [User setCurrentUser:nil];
}

- (BOOL)isLoggedIn
{
    return [_auth canAuthorize];
}

#pragma mark - Users

- (void)updateUserInfo:(User *)user success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure
{
    [self getPath:@"user/info" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __weak NSManagedObjectContext *context = [User mainContext];
        [context performBlockAndWait:^{
            NSDictionary *dictionary = [responseObject valueForKeyPath:@"response.user"];
            [user unpackDictionary:dictionary];
            [user save];
        }];
        
        if (success) {
            success((AFJSONRequestOperation *)operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

- (void)dashboardForUser:(User *)user success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure
{
    [self dashboardForUser:user offset:0 success:success failure:failure];
}

- (void)dashboardForUser:(User *)user offset:(int)offset success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure
{
    NSDictionary *paramaters = @{@"offset" : [NSString stringWithFormat:@"%i", offset]};
    
    [self getPath:@"user/dashboard" parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __weak NSManagedObjectContext *context = [User mainContext];
        [context performBlockAndWait:^{
            // Get all the posts
            NSArray *posts = [responseObject valueForKeyPath:@"response.posts"];
            for (NSDictionary *postDictionary in posts) {
				Post *post = [Post objectWithDictionary:postDictionary];
				post.user = user;
			}
            
			[context save:nil];
        }];
        
        if (success) {
            success((AFJSONRequestOperation *)operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

#pragma mark - Blogs

- (void)postsForBlog:(Blog *)blog success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure
{
    [self postsForBlog:blog offset:0 success:success failure:failure];
}

- (void)postsForBlog:(Blog *)blog offset:(int)offset success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"blog/%@/posts", [blog hostname]];
    NSDictionary *paramaters = @{@"offset" : [NSString stringWithFormat:@"%i", offset]};
    
    [self getPath:path parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __weak NSManagedObjectContext *context = [User mainContext];
        [context performBlockAndWait:^{
            // Update the blog
            NSDictionary *blogDictionary = [responseObject valueForKeyPath:@"response.blog"];
            [blog unpackDictionary:blogDictionary];
            
            // Get all the posts
            NSArray *posts = [responseObject valueForKeyPath:@"response.posts"];
            for (NSDictionary *postDictionary in posts) {
				Post *post = [Post objectWithDictionary:postDictionary];
				post.blog = blog;
			}
            
			[context save:nil];
        }];
        
        if (success) {
            success((AFJSONRequestOperation *)operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

- (void)savePost:(Post *)post forBlog:(Blog *)blog parameters:(NSDictionary *)parameters success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"blog/%@/post", [blog hostname]];
    __weak NSManagedObjectContext *context = [Post mainContext];
    
    [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [context performBlockAndWait:^{
			[post setRemoteID:[NSString stringWithFormat:@"%@", [responseObject valueForKeyPath:@"response.id"]]];
			[post save];
		}];
        
        if (success) {
            success((AFJSONRequestOperation *)operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

- (void)savePost:(Post *)post forBlog:(Blog *)blog success:(TumblrHTTPClientSuccess)success failure:(TumblrHTTPClientFailure)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[[post type] stringTypeValue] forKey:@"type"];
    
    switch ([[post type] entityTypeValue]) {
        case TumblrPostTypeText:
            [parameters setObject:[post title] forKey:@"title"];
            [parameters setObject:[post body] forKey:@"body"];
            break;
            
        case TumblrPostTypePhoto:
            [parameters setObject:[post caption] forKey:@"caption"];
            [parameters setObject:[post url] forKey:@"link"];
            [parameters setObject:[post source] forKey:@"source"];
            break;
            
        case TumblrPostTypePhotoSet:
            // TODO implement photosets
            return;
            break;
            
        case TumblrPostTypeQuote:
            [parameters setObject:[post text] forKey:@"quote"];
            [parameters setObject:[post source] forKey:@"source"];
            break;
            
        case TumblrPostTypeLink:
            [parameters setObject:[post title] forKey:@"title"];
            [parameters setObject:[post url] forKey:@"url"];
            [parameters setObject:[post body] forKey:@"description"];
            break;
            
        case TumblrPostTypeChat:
            [parameters setObject:[post title] forKey:@"title"];
            // TODO dialogue
            break;
            
        case TumblrPostTypeAudio:
            [parameters setObject:[post caption] forKey:@"caption"];
            [parameters setObject:[post url] forKey:@"external_url"];
            break;
            
        case TumblrPostTypeVideo:
            [parameters setObject:[post caption] forKey:@"caption"];
            [parameters setObject:[post url] forKey:@"embed"];
            break;
            
        default:
            break;
    }
    
    [self savePost:post forBlog:blog parameters:parameters success:success failure:failure];
}

@end
