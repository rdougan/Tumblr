//
//  Blog.m
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TKBlog.h"
#import "TKUser.h"

@implementation TKBlog

@dynamic body;
@dynamic postsCount;
@dynamic drafts;
@dynamic title;
@dynamic url;
@dynamic type;
@dynamic queue;
@dynamic primary;
@dynamic ask;
@dynamic askAnon;
@dynamic admin;
@dynamic updatedAt;
@dynamic user;
@dynamic posts;

+ (NSString *)remoteIDField
{
    return @"url";
}

+ (NSArray *)defaultSortDescriptors {
	return [NSArray arrayWithObjects:
			[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO],
			[NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:NO],
			nil];
}

- (void)unpackDictionary:(NSDictionary *)dictionary {
    [super unpackDictionary:dictionary];
    
	self.title = [dictionary safeObjectForKey:@"title"];
	self.body = [dictionary safeObjectForKey:@"description"];
	self.url = [dictionary safeObjectForKey:@"url"];
	self.type = [dictionary safeObjectForKey:@"type"];
	self.updatedAt = [NSDate dateWithTimeIntervalSince1970:[[dictionary safeObjectForKey:@"updated"] intValue]];
	self.admin = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"admin"] boolValue]];
	self.askAnon = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"ask_anon"] boolValue]];
	self.ask = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"ask"] boolValue]];
	self.primary = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"primary"] boolValue]];
	self.queue = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"queue"] intValue]];
	self.postsCount = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"posts"] intValue]];
	self.drafts = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"drafts"] intValue]];
}

- (NSString *)hostname
{
    NSString *hostname = self.url;
    
    // Remove URL prefix
    hostname = [hostname stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    hostname = [hostname stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    
    // Remove last character
    hostname = [hostname substringToIndex:[hostname length] - 1];
    
    return hostname;
}

@end
