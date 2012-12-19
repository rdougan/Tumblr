//
//  TumblrTextField.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrTextField.h"

@implementation TumblrTextField

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height - 1);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1);
    CGContextStrokePath(context);
}

@end
