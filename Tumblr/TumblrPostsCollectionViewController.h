//
//  TumblrPostsCollectionViewController.h
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "SSManagedCollectionViewController.h"

@interface TumblrPostsCollectionViewController : SSManagedCollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL loadingPosts;
@property (nonatomic, assign) int loadOffset;

- (int)totalCount;
- (void)fetchPostsWithOffset:(int)offset;
- (void)checkAndLoadMoreIfNeeded;

@end
