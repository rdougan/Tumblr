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
@property (nonatomic, retain) DTAttributedTextContentView *bodyView;

@property (nonatomic, retain) TKPost *post;

#pragma mark - Sizing helpers

+ (CGFloat)heightForPost:(TKPost *)post;
+ (CGFloat)heightForPost:(TKPost *)post key:(NSString *)key;

#pragma mark - Content helpers

+ (NSAttributedString *)attributedStringForPost:(TKPost *)post key:(NSString *)key;
+ (NSDictionary *)optionsDictionaryForPost:(TKPost *)post key:(NSString *)key;

- (void)didEndDisplaying;

@end
