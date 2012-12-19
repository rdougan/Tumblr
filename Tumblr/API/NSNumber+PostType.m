//
//  NSNumber+PostType.m
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "NSNumber+PostType.h"

@implementation NSNumber (PostType)

- (TumblrPostType)entityTypeValue
{
    int intValue = [self intValue];
    NSAssert(intValue >= 0 && intValue <= 8, @"unsupported entity type");
    return (TumblrPostType)intValue;
}

+ (NSNumber *)numberWithEntityType:(TumblrPostType)entityType
{
    return [NSNumber numberWithInt:(int)entityType];
}

- (NSString *)stringTypeValue
{
    switch ([self entityTypeValue]) {
        case TumblrPostTypeText:
            return @"text";
            break;
            
        case TumblrPostTypePhoto:
            return @"photo";
            break;
            
        case TumblrPostTypeQuote:
            return @"quote";
            break;
            
        case TumblrPostTypeLink:
            return @"link";
            break;
            
        case TumblrPostTypeChat:
            return @"chat";
            break;
            
        case TumblrPostTypeAudio:
            return @"audio";
            break;
            
        case TumblrPostTypeVideo:
            return @"video";
            break;
            
        default:
            return nil;
            break;
    }
}

@end
