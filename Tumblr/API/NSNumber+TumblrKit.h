//
//  NSNumber+PostType.h
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (TumblrKit)

- (TKPostType)entityTypeValue;
+ (NSNumber *)numberWithEntityType:(TKPostType)entityType;
- (NSString *)stringTypeValue;

@end
