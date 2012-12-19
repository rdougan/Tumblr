//
//  TumblrBlogViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrBlogViewController.h"

#import "TumblrPostsViewController.h"

@interface TumblrBlogViewController ()

@end

@implementation TumblrBlogViewController {
    Blog *_blog;
}

- (id)initWithRemoteID:(NSString *)remoteID
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // find the blog
        _blog = [Blog objectWithRemoteID:remoteID];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:[_blog title]];
    
    [self fetchPostsWithOffset:0];
}

#pragma mark - TumblrPostsViewController

- (int)totalCount
{
    return [[_blog postsCount] intValue];
}

- (void)fetchPosts
{
    [[TumblrHTTPClient sharedClient] postsForBlog:_blog offset:self.loadOffset success:^(AFJSONRequestOperation *operation, id responseObject) {
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
	return [NSPredicate predicateWithFormat:@"blog = %@", _blog];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
