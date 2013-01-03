//
//  TumblrPostCollectionViewCell.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPostCollectionViewCell.h"

@implementation TumblrPostCollectionViewCell {

}

@synthesize blogNameLabel = _blogNameLabel,
rebloggedNameLabel = _rebloggedNameLabel,
likeButton = _likeButton,
reblogButton = _reblogButton,
bodyView = _bodyView;

@synthesize post = _post;

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
        
        _bodyView = [[DTAttributedTextContentView alloc] initWithFrame:CGRectZero];
//        [_bodyView setBackgroundColor:[UIColor redColor]];
//        [_bodyView setEditable:NO];
//        [_bodyView setScrollEnabled:NO];
//        [_bodyView setFont:[UIFont systemFontOfSize:15.0f]];
        [self addSubview:_bodyView];
    }
    return self;
}

#pragma mark - Sizing helpers

+ (CGFloat)heightForPost:(TKPost *)post
{
    return 60.0f + [self heightForPost:post key:@"body"] + 10.0f;
}

+ (CGFloat)heightForPost:(TKPost *)post key:(NSString *)key
{
    NSAttributedString *attributedString = [self attributedStringForPost:post key:key];
    
    // TODO dont create this every time
    DTAttributedTextContentView *view = [[DTAttributedTextContentView alloc] initWithAttributedString:attributedString width:580.0f];
    CGSize size = [view sizeThatFits:CGSizeMake(580.0f, 3000.0f)];
    
    return size.height;
}

#pragma mark - Content helpers

+ (NSAttributedString *)attributedStringForPost:(TKPost *)post key:(NSString *)key
{
    NSString *value = [post valueForKey:key];
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:[self optionsDictionaryForPost:post key:key] documentAttributes:nil];
    
    return attributedString;
}

+ (NSDictionary *)optionsDictionaryForPost:(TKPost *)post key:(NSString *)key
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:@"Helvetica" forKey:DTDefaultFontFamily];
    
    return (NSDictionary *)options;
}

#pragma mark - Layout

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
    
    frame = CGRectMake(10.0f, 60.0f, 580.0f, 0);
    frame.size.height = [[self class] heightForPost:_post key:@"body"];
    [self.bodyView setFrame:frame];
}

- (void)didEndDisplaying
{
    
}

#pragma mark - Post

- (void)setPost:(TKPost *)post
{
    _post = post;
    
    [_blogNameLabel setText:[_post blogName]];
    
//    if ([_post isReblogged]) {
//        [_rebloggedNameLabel setText:[_post rebloggedFromName]];
//    } else {
//        [_rebloggedNameLabel setText:@""];
//    }

    [_rebloggedNameLabel setText:[[_post type] stringTypeValue]];
    
    [_likeButton setTitle:([_post isLiked]) ? @"unlike" : @"like" forState:UIControlStateNormal];
    
    [_bodyView setAttributedString:[[self class] attributedStringForPost:_post key:@"body"]];
    
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
