//
//  TumblrBlogViewController.h
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrPostsViewController.h"

@interface TumblrBlogViewController : TumblrPostsViewController

- (id)initWithRemoteID:(NSString *)remoteID;

@end
