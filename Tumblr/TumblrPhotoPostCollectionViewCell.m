//
//  TumblrPhotoPostCollectionViewCell.m
//  Tumblr
//
//  Created by Robert Dougan on 12/21/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPhotoPostCollectionViewCell.h"

#import "UIImageView+AFNetworking.h"

@implementation TumblrPhotoPostCollectionViewCell

@synthesize imageView = _imageView;

+ (TKPhoto *)photoForPost:(TKPost *)post
{
    return [post.photoSet firstPhoto];
}

#pragma mark - Sizing helpers

+ (CGFloat)imageHeightForPhoto:(TKPhoto *)photo
{
    return [self imageHeightForPhoto:photo width:580.0f];
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
    CGFloat height = [super heightForPost:post];
    TKPhoto *photo = [self photoForPost:post];
    
    if (photo) {
        height = height + [[self class] imageHeightForPhoto:photo] + 10.0f;
        height = height + [[self class] heightForPost:post key:@"caption"] + 10.0f;
    }
    
    return height;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    TKPhoto *photo = [[self class] photoForPost:self.post];
    
    if (photo) {
        CGRect frame = self.bodyView.frame;
        frame.origin.y = frame.origin.y + [[self class] imageHeightForPhoto:photo] + 10.0f;
        frame.size.height = [[self class] heightForPost:self.post key:@"caption"];
        [self.bodyView setFrame:frame];
    }
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
            frame.origin.y = 60.0f;
            frame.origin.x = 10.0f;
            frame.size.width = frame.size.width - 20.0f;
            frame.size.height = frame.size.height - 70.0f;
            
            self.imageView = [[UIImageView alloc] initWithFrame:frame];
            [self.imageView setBackgroundColor:[UIColor lightGrayColor]];
            [self addSubview:self.imageView];
        }
        
        NSURL *url = [NSURL URLWithString:[[photo closestSizeForWidth:500.0f] url]];
        
        CGFloat ratio = self.imageView.bounds.size.width / [[photo width] floatValue];
        
        // Resize imageView
        frame = self.imageView.frame;
        frame.size.height = [[photo height] floatValue] * ratio;
        [self.imageView setFrame:frame];
        
        // Load the image
        [self.imageView setImageWithURL:url];
        
        [self.bodyView setAttributedString:[[self class] attributedStringForPost:self.post key:@"caption"]];
    }
}

- (void)didEndDisplaying
{
    [_imageView cancelImageRequestOperation];
}

@end
