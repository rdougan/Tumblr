//
//  TumblrPhotoPostCollectionViewCell.m
//  Tumblr
//
//  Created by Robert Dougan on 12/21/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPhotoPostCollectionViewCell.h"

#import "OLImageView+Tumblr.h"

@implementation TumblrPhotoPostCollectionViewCell

@synthesize imageView = _imageView;

+ (TKPhoto *)photoForPost:(TKPost *)post
{
    return [post.photoSet firstPhoto];
}

#pragma mark - Sizing helpers

+ (CGFloat)imageHeightForPhoto:(TKPhoto *)photo
{
    return [self imageHeightForPhoto:photo width:600.0f];
}

+ (CGFloat)imageHeightForPhoto:(TKPhoto *)photo width:(float)width
{
    CGFloat ratio = width / [[photo width] floatValue];
    return ([[photo height] floatValue] * ratio);
}

+ (CGSize)adjustedSizeWithWidth:(CGFloat)width height:(CGFloat)height expectedWidth:(CGFloat)expectedWidth
{
    CGFloat ratio = expectedWidth / width;
    return CGSizeMake(expectedWidth, height * ratio);
}

+ (CGFloat)heightForPost:(TKPost *)post
{
    CGFloat height = 0;
    TKPhoto *photo = [self photoForPost:post];
    
    if (photo) {
        height = height + [[self class] imageHeightForPhoto:photo];
    }
    
    CGFloat captionHeight = [[self class] heightForPost:post key:@"caption"];
    
    height = height + 10.0f + ((captionHeight > 0) ? captionHeight + 10.0f : 0);
    height = height + 15.0f + 10.0f;
    
    return height;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect frame = self.imageView.frame;
    
    // Body
    frame.origin.x = 10.0f;
    frame.origin.y = frame.origin.y + frame.size.height + 10.0f;
    frame.size.width = 580.0f;
    frame.size.height = [[self class] heightForPost:self.post key:@"caption"];
    [self.bodyView setFrame:frame];
    
    // Blog name
    frame = self.bodyView.frame;
    frame.origin.y = frame.origin.y + ((frame.size.height > 0) ? frame.size.height + 10.0f : 0);
    frame.size.width = 580.0f;
    frame.size.height = 21.0f;
    [self.blogNameLabel setFrame:frame];
    [self.blogNameLabel sizeToFit];
    
    // Reblogged blog name
    frame = self.blogNameLabel.frame;
    frame.origin.x = frame.origin.x + frame.size.width + 10.0f;
    [self.rebloggedNameLabel setFrame:frame];
    [self.rebloggedNameLabel sizeToFit];
    
    // Reblog button
    [self.reblogButton sizeToFit];
    frame = self.reblogButton.frame;
    frame.origin.y = 10.0f;
    frame.origin.x = self.bounds.size.width - frame.size.width - 10.0f;
    [self.reblogButton setFrame:frame];
    
    // Like button
    [self.likeButton sizeToFit];
    frame = self.likeButton.frame;
    frame.origin.y = 10.0f;
    frame.origin.x = self.bounds.size.width - self.reblogButton.frame.size.width - 10.0f - frame.size.width - 10.0f;
    [self.likeButton setFrame:frame];
}

#pragma mark - Post

- (void)setPost:(TKPost *)post
{
    [super setPost:post];
    
    TKPhoto *photo = [[self class] photoForPost:post];
    
    if (photo) {
        CGRect frame;
        
        if (!self.imageView) {
            CGRect frame = self.bounds;
            frame.origin.y = 0;
            frame.origin.x = 0;
            frame.size.width = frame.size.width;
            frame.size.height = frame.size.height;
            
            self.imageView = [[OLImageView alloc] initWithFrame:frame];
            [self.imageView setBackgroundColor:[UIColor lightGrayColor]];
            [self addSubview:self.imageView];
            [self sendSubviewToBack:self.imageView];
        }
        
        NSURL *url = [NSURL URLWithString:[[photo closestSizeForWidth:600.0f] url]];
        
        CGFloat ratio = self.imageView.bounds.size.width / [[photo width] floatValue];
        
        // Resize imageView
        frame = self.imageView.frame;
        frame.size.height = [[photo height] floatValue] * ratio;
        [self.imageView setFrame:frame];
        
        // Load the image
        [self.imageView setImageWithURL:url];
    }
  
    [self.bodyView loadHTMLString:[[self class] stringForPost:self.post key:@"caption"] baseURL:nil];
//    [self.bodyView setAttributedString:[[self class] attributedStringForPost:self.post key:@"caption"]];
}

- (void)didEndDisplaying
{
    [_imageView cancelImageRequestOperation];
}

@end
