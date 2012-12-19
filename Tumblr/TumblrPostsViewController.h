//
//  TumblrPostsViewController.h
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "SSManagedTableViewController.h"

@interface TumblrPostsViewController : SSManagedTableViewController

@property (nonatomic, assign) BOOL loadingPosts;
@property (nonatomic, assign) int loadOffset;

- (int)totalCount;
- (void)fetchPostsWithOffset:(int)offset;
- (void)checkAndLoadMoreIfNeeded;

@end
