//
//  TumblrVideoPostCollectionViewCell.m
//  Tumblr
//
//  Created by Robert Dougan on 1/10/13.
//  Copyright (c) 2013 Robert Dougan. All rights reserved.
//

#import "TumblrVideoPostCollectionViewCell.h"

@implementation TumblrVideoPostCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - Sizing helpers

+ (CGFloat)heightForPost:(TKPost *)post
{
    return [super heightForPost:post];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    // Quote
//    CGRect frame = self.quoteLabel.frame;
//    frame.size.height = [self.quoteLabel sizeThatFits:CGSizeMake(frame.size.width, 4000.0f)].height;
//    [self.quoteLabel setFrame:frame];
//    
//    // Source
//    frame = self.sourceLabel.frame;
//    frame.origin.y = self.quoteLabel.frame.origin.y + self.quoteLabel.frame.size.height + 10.0f;
//    frame.size.height = [self.sourceLabel sizeThatFits:CGSizeMake(frame.size.width, 4000.0f)].height;
//    [self.sourceLabel setFrame:frame];
//    
//    // Blog name
//    frame = self.sourceLabel.frame;
//    frame.size.width = 580.0f;
//    frame.origin.x = 10.0f;
//    frame.origin.y = frame.origin.y + frame.size.height + 40.0f;
//    [self.blogNameLabel setFrame:frame];
//    [self.blogNameLabel sizeToFit];
//    
//    // Reblogged blog name
//    frame = self.blogNameLabel.frame;
//    frame.origin.x = frame.origin.x + frame.size.width + 10.0f;
//    [self.rebloggedNameLabel setFrame:frame];
//    [self.rebloggedNameLabel sizeToFit];
}

#pragma mark - Post

- (void)setPost:(TKPost *)post
{
    [super setPost:post];
    
//    [self.quoteLabel setText:[post text]];
}

@end
