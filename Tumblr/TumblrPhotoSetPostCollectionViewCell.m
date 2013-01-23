//
//  TumblrPhotoSetPostCollectionViewCell.m
//  Tumblr
//
//  Created by Robert Dougan on 12/22/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPhotoSetPostCollectionViewCell.h"

#import "OLImageView+Tumblr.h"

@implementation TumblrPhotoSetPostCollectionViewCell

@synthesize imageViews = _imageViews;

#pragma mark - Sizing helpers

+ (CGFloat)heightForPost:(TKPost *)post
{
    CGFloat height = [super heightForPost:post];
    CGFloat photoSetHeight = [[self class] heightForPhotoSet:post.photoSet];
    
    return height + photoSetHeight;
}

+ (CGFloat)heightForPhotoSet:(TKPhotoSet *)photoSet
{
    NSDictionary *frameInformation = [photoSet frameInformationForWidth:600.0f spacing:0];
    CGFloat height = lroundf([[frameInformation objectForKey:@"height"] floatValue]);
    
    return height;
}

+ (TKPhoto *)photoForPost:(TKPost *)post
{
    return nil;
}

#pragma mark - Layout

- (OLImageView *)imageViewAtIndex:(int)index
{
    NSString *indexString = [NSString stringWithFormat:@"%i", index];
    
    if (!self.imageViews) {
        self.imageViews = [NSMutableDictionary dictionary];
    }
    
    if ([self.imageViews objectForKey:indexString]) {
        OLImageView *imageView = [self.imageViews objectForKey:indexString];
        return imageView;
    } else {
        OLImageView *imageView = [[OLImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:imageView];
        [self sendSubviewToBack:imageView];
        [self.imageViews setObject:imageView forKey:indexString];
        return imageView;
    }
}

- (NSDictionary *)indexInformationForPhoto:(TKPhoto *)photo atIndex:(int)index
{
    NSMutableDictionary *information = [NSMutableDictionary dictionary];
    int totalPhotos = 0;
    
    NSString *layoutString = [NSString stringWithFormat:@"%@", photo.photoSet.layout];
    unsigned int len = [layoutString length];
    unichar buffer[len + 1];
    [layoutString getCharacters:buffer range:NSMakeRange(0, len)];
    
    for (int row = 0; row < len; ++row) {
        int rowCount = [[NSString stringWithFormat:@"%c", buffer[row]] intValue];
        int column = index % rowCount;
        
        totalPhotos = totalPhotos + rowCount;
        
        if (index < totalPhotos) {
            [information setObject:[NSNumber numberWithInt:column] forKey:@"column"];
            [information setObject:[NSNumber numberWithInt:row] forKey:@"row"];
            [information setObject:[NSNumber numberWithInt:rowCount] forKey:@"rowCount"];
            break;
        }
    }
    
    return (NSDictionary *)information;
}

- (CGRect)frameForPhoto:(TKPhoto *)photo atIndex:(int)index
{
    NSDictionary *frameInformation = [photo.photoSet frameInformationForWidth:600.0f spacing:0];
    NSArray *frames = [frameInformation objectForKey:@"frames"];
    NSDictionary *frame = [frames objectAtIndex:index];
    
    return CGRectMake([[frame objectForKey:@"x"] floatValue], [[frame objectForKey:@"y"] floatValue], [[frame objectForKey:@"width"] floatValue], [[frame objectForKey:@"height"] floatValue]);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __block CGRect lastFrame;
    NSArray *photos = [self.post.photoSet sortedPhotos];
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OLImageView *imageView = [self imageViewAtIndex:idx];

        CGRect frame = [self frameForPhoto:(TKPhoto *)obj atIndex:idx];
        [imageView setFrame:frame];
        [imageView setAlpha:1.0f];
        
        lastFrame = frame;
    }];
    
    int difference = [self.imageViews count] - [photos count];
    if (difference > 0) {
        for (int i = 0; i < difference; i++) {
            OLImageView *imageView = [self.imageViews objectForKey:[NSString stringWithFormat:@"%i", [photos count] + i]];
            [imageView setAlpha:0];
        }
    }
    
    // Body
    CGRect frame = CGRectMake(10.0f, lastFrame.size.height + lastFrame.origin.y + 10.0f, 580.0f, 0);
    frame.size.height = [[self class] heightForPost:self.post key:@"body"];
    [self.bodyView setFrame:frame];
    
    // Blog name
    frame = self.bodyView.frame;
    frame.origin.y = frame.origin.y + ((frame.size.height > 0) ? frame.size.height + 10.0f : 0);
    frame.size.width = 580.0f;
    [self.blogNameLabel setFrame:frame];
    [self.blogNameLabel sizeToFit];
    
    // Reblogged blog name
    frame = self.blogNameLabel.frame;
    frame.origin.x = frame.origin.x + frame.size.width + 10.0f;
    [self.rebloggedNameLabel setFrame:frame];
    [self.rebloggedNameLabel sizeToFit];
}

- (void)setPost:(TKPost *)post
{
    [super setPost:post];
    
    NSArray *photos = [self.post.photoSet sortedPhotos];
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OLImageView *imageView = [self imageViewAtIndex:idx];
        
        TKPhotoSize *size = [(TKPhoto *)obj closestSizeForWidth:580.0f];
        [imageView cancelImageRequestOperation];
        [imageView setImage:nil];
        [imageView setImageWithURL:[NSURL URLWithString:[size url]]];
    }];
    
    int difference = [self.imageViews count] - [photos count];
    if (difference > 0) {
        for (int i = 0; i < difference; i++) {
            OLImageView *imageView = [self.imageViews objectForKey:[NSString stringWithFormat:@"%i", [photos count] + i]];
            [imageView cancelImageRequestOperation];
            [imageView setImage:nil];
        }
    }
    
    //[imageView setImageWithURL:[NSURL URLWithString:[(TKPhoto *)obj url]]];
}

@end
