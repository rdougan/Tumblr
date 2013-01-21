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
        [_blogNameLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_blogNameLabel setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:_blogNameLabel];
        
        _rebloggedNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_rebloggedNameLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self addSubview:_rebloggedNameLabel];
        
        _likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_likeButton addTarget:self action:@selector(toggleLiked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _reblogButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_reblogButton setTitle:@"reblog" forState:UIControlStateNormal];
        [_reblogButton addTarget:self action:@selector(reblog:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reblogButton];
        
        _bodyView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [_bodyView setBackgroundColor:[UIColor redColor]];
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
    return 10.0f + [self heightForPost:post key:@"body"] + 10.0f + 15.0f + 10.0f;
}

+ (CGFloat)heightForPost:(TKPost *)post key:(NSString *)key
{
    NSString *string = [self stringForPost:post key:key];
    
    // TODO dont create this every time
    CGRect frame = CGRectMake(0, 0, 580.0f, 100.0f);
    UIWebView *webview = [[UIWebView alloc] initWithFrame:frame];
    [webview loadHTMLString:string baseURL:nil];
    
    NSString *output = [webview stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];

    NSLog(@"output:%@", output);
    
//    CGFloat height = lroundf(size.height);
//    if (height > 0) {
//        height = height;
//    }
    
    return 0;
}

#pragma mark - Content helpers

+ (NSString *)stringForPost:(TKPost *)post key:(NSString *)key
{
    NSString *value = [post valueForKey:key];
    NSString *css = @"<style>body {font-family: Helvetica; font-size: 14px;}blockquote {border-left: solid 4px #8c8c8c;padding-left: 4px;}</style>";
    
    return [NSString stringWithFormat:@"%@%@", css, value];
}

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
    [options setObject:[UIColor grayColor] forKey:DTDefaultLinkColor];
    [options setObject:[NSNumber numberWithFloat:1.3f] forKey:NSTextSizeMultiplierDocumentOption];
    
    return (NSDictionary *)options;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect frame;
    
    // Reblog button
    [_reblogButton sizeToFit];
    frame = _reblogButton.frame;
    frame.origin.y = 10.0f;
    frame.origin.x = self.bounds.size.width - frame.size.width - 10.0f;
    [_reblogButton setFrame:frame];
    
    // Like button
    [_likeButton sizeToFit];
    frame = _likeButton.frame;
    frame.origin.y = 10.0f;
    frame.origin.x = self.bounds.size.width - _reblogButton.frame.size.width - 10.0f - frame.size.width - 10.0f;
    [_likeButton setFrame:frame];
    
    // Body
    frame = CGRectMake(10.0f, 10.0f, 580.0f, 0);
    frame.size.height = [[self class] heightForPost:_post key:@"body"];
    [self.bodyView setFrame:frame];
    
    // Blog name
    frame = self.bodyView.frame;
    frame.size.width = 580.0f;
    frame.origin.x = 10.0f;
    frame.origin.y = frame.origin.y + frame.size.height + 10.0f;
    [self.blogNameLabel setFrame:frame];
    [self.blogNameLabel sizeToFit];
    
    // Reblogged blog name
    frame = self.blogNameLabel.frame;
    frame.origin.x = frame.origin.x + frame.size.width + 10.0f;
    [self.rebloggedNameLabel setFrame:frame];
    [self.rebloggedNameLabel sizeToFit];
}

- (void)didEndDisplaying
{
    
}

#pragma mark - Post

- (void)setPost:(TKPost *)post
{
    _post = post;
    
    [_blogNameLabel setText:[_post blogName]];
    
    if ([_post isReblogged]) {
        [_rebloggedNameLabel setText:[_post rebloggedFromName]];
    } else {
        [_rebloggedNameLabel setText:@""];
    }
    
    [_likeButton setTitle:([_post isLiked]) ? @"unlike" : @"like" forState:UIControlStateNormal];
    
//    [_bodyView setAttributedString:[[self class] attributedStringForPost:_post key:@"body"]];
    
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
