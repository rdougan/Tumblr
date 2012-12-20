//
//  TumblrPostCollectionViewCell.h
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TumblrPostCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) UILabel *blogNameLabel;
@property (nonatomic, retain) UILabel *rebloggedNameLabel;
@property (nonatomic, retain) UIButton *likeButton;
@property (nonatomic, retain) UIButton *reblogButton;

- (void)setPost:(TKPost *)post;

@end
