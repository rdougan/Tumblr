//
//  TumblrDashboardViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrDashboardViewController.h"

@implementation TumblrDashboardViewController {
    TKUser *_user;
}

- (id)initWithRemoteID:(NSString *)remoteID
{
    self = [super init];
    if (self) {
        // find the user
        _user = [TKUser objectWithRemoteID:remoteID];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Dashboard"];
 
    [self fetchPostsWithOffset:0];
}

#pragma mark - TumblrPostsViewController

- (int)totalCount
{
    // Dashboard cap seems to be 260...
    return 250;
}

- (void)fetchPosts
{
    [[TKHTTPClient sharedClient] dashboardForUser:_user offset:self.loadOffset success:^(AFJSONRequestOperation *operation, id responseObject) {
        self.loadOffset = self.loadOffset + 20;
        self.loadingPosts = NO;

        [self checkAndLoadMoreIfNeeded];
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        NSLog(@"failure: %@", error);

        self.loadingPosts = NO;
    }];
}

#pragma mark - SSManagedViewController

- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"dashboardUser = %@", _user];
}

@end

