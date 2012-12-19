//
//  TumblrBlogViewController.h
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrPostsCollectionViewController.h"

@interface TumblrBlogViewController : TumblrPostsCollectionViewController

- (id)initWithRemoteID:(NSString *)remoteID;

@end
