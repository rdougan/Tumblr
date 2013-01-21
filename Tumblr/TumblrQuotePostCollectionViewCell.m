//
//  TumblrQuotePostCollectionViewCell.m
//  Tumblr
//
//  Created by Robert Dougan on 1/10/13.
//  Copyright (c) 2013 Robert Dougan. All rights reserved.
//

#import "TumblrQuotePostCollectionViewCell.h"

@implementation TumblrQuotePostCollectionViewCell

@synthesize quoteLabel = _quoteLabel,
sourceLabel = _sourceLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 40.0f, 520.0f, 0)];
        [self.quoteLabel setBackgroundColor:[UIColor darkGrayColor]];
        [self.quoteLabel setFont:[[self class] fontForQuote]];
        [self.quoteLabel setNumberOfLines:0];
        [self addSubview:self.quoteLabel];
        
        self.sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 40.0f, 500.0f, 0)];
        [self.sourceLabel setFont:[[self class] fontForSource]];
        [self.sourceLabel setNumberOfLines:0];
        [self addSubview:self.sourceLabel];
    }
    return self;
}

#pragma mark - Sizing helpers

+ (CGFloat)heightForPost:(TKPost *)post
{
    CGFloat height = 0;
    
    // Height of the quote
    UILabel *quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 520.0f, 0)];
    [quoteLabel setNumberOfLines:0];
    [quoteLabel setFont:[self fontForQuote]];
    [quoteLabel setText:[post text]];
    
    height = 40.0f + [quoteLabel sizeThatFits:CGSizeMake(quoteLabel.frame.size.width, 4000.0f)].height;
    
    // Height of the source
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500.0f, 0)];
    [sourceLabel setNumberOfLines:0];
    [sourceLabel setFont:[self fontForSource]];
    [sourceLabel setText:[post source]];
    
    height = height + 10.0f + [sourceLabel sizeThatFits:CGSizeMake(sourceLabel.frame.size.width, 4000.0f)].height + 40.0f;
    
    // Blog name
    height = height + 15.0f + 10.0f;
    
    return height;
}

#pragma mark - Layout

+ (UIFont *)fontForQuote
{
    return [UIFont fontWithName:@"Baskerville-SemiBold" size:26.0f];
}

+ (UIFont *)fontForSource
{
    return [UIFont fontWithName:@"Arial-ItalicMT" size:13.0f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Quote
    CGRect frame = self.quoteLabel.frame;
    frame.size.height = [self.quoteLabel sizeThatFits:CGSizeMake(frame.size.width, 4000.0f)].height;
    [self.quoteLabel setFrame:frame];
    
    // Source
    frame = self.sourceLabel.frame;
    frame.origin.y = self.quoteLabel.frame.origin.y + self.quoteLabel.frame.size.height + 10.0f;
    frame.size.height = [self.sourceLabel sizeThatFits:CGSizeMake(frame.size.width, 4000.0f)].height;
    [self.sourceLabel setFrame:frame];
    
    // Blog name
    frame = self.sourceLabel.frame;
    frame.size.width = 580.0f;
    frame.origin.x = 10.0f;
    frame.origin.y = frame.origin.y + frame.size.height + 40.0f;
    [self.blogNameLabel setFrame:frame];
    [self.blogNameLabel sizeToFit];
    
    // Reblogged blog name
    frame = self.blogNameLabel.frame;
    frame.origin.x = frame.origin.x + frame.size.width + 10.0f;
    [self.rebloggedNameLabel setFrame:frame];
    [self.rebloggedNameLabel sizeToFit];
}

#pragma mark - Post

- (void)setPost:(TKPost *)post
{
    [super setPost:post];
    
    [self.quoteLabel setText:[post text]];
    [self.sourceLabel setText:[post source]];
}

@end
