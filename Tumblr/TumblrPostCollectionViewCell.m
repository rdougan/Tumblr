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
rebloggedNameLabel = _rebloggedNameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _blogNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rebloggedNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_blogNameLabel];
        [self addSubview:_rebloggedNameLabel];
    }
    return self;
}

- (void)setPost:(TKPost *)post
{
    _post = post;
    
    [_blogNameLabel setText:[_post blogName]];
    
    if ([_post isReblogged]) {
        [_rebloggedNameLabel setText:[_post rebloggedFromName]];
    } else {
        [_rebloggedNameLabel setText:@""];
    }
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [_blogNameLabel setFrame:CGRectMake(10.0f, 10.0f, 0, 0)];
    [_blogNameLabel sizeToFit];
    
    CGRect frame = CGRectMake(_blogNameLabel.frame.origin.x + _blogNameLabel.frame.size.width + 10.0f, 10.0f, 0, 0);
    [_rebloggedNameLabel setFrame:frame];
    [_rebloggedNameLabel sizeToFit];
}

@end
