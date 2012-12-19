//
//  TKChat.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TKChat.h"
#import "TKPost.h"

@implementation TKChat

@dynamic label;
@dynamic name;
@dynamic phrase;
@dynamic remoteID;
@dynamic post;

+ (NSString *)remoteIDField
{
    return @"remoteID";
}

- (void)unpackDictionary:(NSDictionary *)dictionary {
    [super unpackDictionary:dictionary];
    
	self.label = [dictionary safeObjectForKey:@"label"];
	self.name = [dictionary safeObjectForKey:@"name"];
	self.phrase = [dictionary safeObjectForKey:@"phrase"];
}

@end
