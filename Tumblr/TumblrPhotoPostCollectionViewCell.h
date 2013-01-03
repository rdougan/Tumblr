//
//  TumblrPhotoPostCollectionViewCell.h
//  Tumblr
//
//  Created by Robert Dougan on 12/21/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPostCollectionViewCell.h"

@interface TumblrPhotoPostCollectionViewCell : TumblrPostCollectionViewCell

@property (nonatomic, retain) UIImageView *imageView;

+ (CGFloat)imageHeightForPhoto:(TKPhoto *)photo;
+ (CGFloat)imageHeightForPhoto:(TKPhoto *)photo width:(float)width;
+ (CGSize)adjustedSizeWithWidth:(CGFloat)width height:(CGFloat)height expectedWidth:(CGFloat)expectedWidth;

@end
