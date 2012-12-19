//
//  TumblrCreatePostViewController.h
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPostFieldPadding 10.0f

@interface TumblrCreatePostViewController : UIViewController

@property (nonatomic, retain) TKBlog *blog;

- (id)init;

- (TKPost *)post;

@end
