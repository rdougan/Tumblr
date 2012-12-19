//
//  TumblrCreateTextPostViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrCreateTextPostViewController.h"

#import "TumblrTextField.h"
#import "SSTextView.h"

@implementation TumblrCreateTextPostViewController {
    TumblrTextField *_titleField;
    SSTextView *_bodyField;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"Text"];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(kPostFieldPadding, kPostFieldPadding, kPostFieldPadding, kPostFieldPadding);
    
    _titleField = [[TumblrTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 42.0f)];
    [_titleField setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [_titleField setTextEdgeInsets:edgeInsets];
    [_titleField setFont:[UIFont systemFontOfSize:18.0f]];
    [_titleField setPlaceholder:@"title"];
    [self.view addSubview:_titleField];
    
    CGRect frame = CGRectMake(0, _titleField.frame.origin.y + _titleField.frame.size.height, self.view.bounds.size.width, 0);
    frame.size.height = self.view.bounds.size.height - _titleField.frame.size.height;
    _bodyField = [[SSTextView alloc] initWithFrame:frame];
    [_bodyField setContentInset:edgeInsets];
    [_bodyField setFont:[UIFont systemFontOfSize:18.0f]];
    [_bodyField setPlaceholder:@"description"];
    [_bodyField setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_bodyField];
    
    [_titleField becomeFirstResponder];
}

#pragma mark - TumblrCreatePostViewController

- (TKPost *)post
{
    TKPost *post = [[TKPost alloc] init];
    [post setType:[NSNumber numberWithEntityType:TKPostTypeText]];
    [post setTitle:[_titleField text]];
    [post setBody:[_bodyField text]];
    return post;
}

@end
