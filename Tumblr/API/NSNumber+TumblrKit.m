//
//  NSNumber+PostType.m
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "NSNumber+TumblrKit.h"

@implementation NSNumber (TumblrKit)

- (TKPostType)entityTypeValue
{
    int intValue = [self intValue];
    NSAssert(intValue >= 0 && intValue <= 8, @"unsupported entity type");
    return (TKPostType)intValue;
}

+ (NSNumber *)numberWithEntityType:(TKPostType)entityType
{
    return [NSNumber numberWithInt:(int)entityType];
}

- (NSString *)stringTypeValue
{
    switch ([self entityTypeValue]) {
        case TKPostTypeText:
            return @"text";
            break;
            
        case TKPostTypePhoto:
            return @"photo";
            break;
            
        case TKPostTypePhotoSet:
            return @"photoset";
            break;
            
        case TKPostTypeQuote:
            return @"quote";
            break;
            
        case TKPostTypeLink:
            return @"link";
            break;
            
        case TKPostTypeChat:
            return @"chat";
            break;
            
        case TKPostTypeAudio:
            return @"audio";
            break;
            
        case TKPostTypeVideo:
            return @"video";
            break;
        
        case TKPostTypeAnswer:
            return @"answer";
            break;
            
        default:
            return nil;
            break;
    }
}

@end
