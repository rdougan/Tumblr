//
//  TumblrPostCollectionViewCell.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPostCollectionViewCell.h"

@implementation TumblrPostCollectionViewCell {
    TKPost *_post;
}

@synthesize blogNameLabel = _blogNameLabel,
rebloggedNameLabel = _rebloggedNameLabel,
likeButton = _likeButton,
reblogButton = _reblogButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _blogNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_blogNameLabel];
        
        _rebloggedNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_rebloggedNameLabel];
        
        _likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_likeButton addTarget:self action:@selector(toggleLiked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _reblogButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_reblogButton setTitle:@"reblog" forState:UIControlStateNormal];
        [_reblogButton addTarget:self action:@selector(reblog:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reblogButton];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect frame;
    
    [_blogNameLabel setFrame:CGRectMake(10.0f, 10.0f, 0, 0)];
    [_blogNameLabel sizeToFit];
    
    frame = CGRectMake(_blogNameLabel.frame.origin.x + _blogNameLabel.frame.size.width + 10.0f, 10.0f, 0, 0);
    [_rebloggedNameLabel setFrame:frame];
    [_rebloggedNameLabel sizeToFit];
    
    [_reblogButton sizeToFit];
    frame = _reblogButton.frame;
    frame.origin.y = 10.0f;
    frame.origin.x = self.bounds.size.width - frame.size.width - 10.0f;
    [_reblogButton setFrame:frame];
    
    [_likeButton sizeToFit];
    frame = _likeButton.frame;
    frame.origin.y = 10.0f;
    frame.origin.x = self.bounds.size.width - _reblogButton.frame.size.width - 10.0f - frame.size.width - 10.0f;
    [_likeButton setFrame:frame];
}

#pragma mark - Post

- (void)setPost:(TKPost *)post
{
    _post = post;
    
    [_blogNameLabel setText:[_post blogName]];
    
    if ([_post isReblogged]) {
        [_rebloggedNameLabel setText:[_post rebloggedFromName]];
    } else {
        [_rebloggedNameLabel setText:@""];
    }
    
    [_likeButton setTitle:([_post isLiked]) ? @"unlike" : @"like" forState:UIControlStateNormal];
    
    [self layoutSubviews];
}

- (void)toggleLiked:(id)sender
{
    [_post toggleLikedWithSuccess:nil failure:^(AFJSONRequestOperation *operation, NSError *error) {
        NSLog(@"error toggling liked: %@", error);
    }];
}

- (void)reblog:(id)sender
{
    [[TKHTTPClient sharedClient] reblogPost:_post blog:[TKBlog defaultBlog] comment:@"testing" success:nil failure:^(AFJSONRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
