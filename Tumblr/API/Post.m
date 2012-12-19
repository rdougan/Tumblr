//
//  Post.m
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "Post.h"
#import "Blog.h"

@implementation Post

@dynamic type;
@dynamic blogName;
@dynamic postURL;
@dynamic format;
@dynamic reblogKey;
@dynamic tags;
@dynamic sourceURL;
@dynamic sourceTitle;
@dynamic state;
@dynamic blog;
@dynamic user;
@dynamic liked;
@dynamic createdAt;

@dynamic title;
@dynamic url;
@dynamic body;
@dynamic photos;
@dynamic caption;
@dynamic width;
@dynamic height;
@dynamic text;
@dynamic source;
@dynamic dialogue;
@dynamic plays;
@dynamic albumArt;
@dynamic artist;
@dynamic album;
@dynamic trackName;
@dynamic trackNumber;
@dynamic year;
@dynamic askingName;
@dynamic askingURL;
@dynamic question;
@dynamic answer;

+ (NSString *)remoteIDField
{
    return @"id";
}

+ (NSArray *)defaultSortDescriptors {
	return [NSArray arrayWithObjects:
			[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO],
			nil];
}

- (void)unpackDictionary:(NSDictionary *)dictionary {
    [super unpackDictionary:dictionary];
    
	self.blogName = [dictionary safeObjectForKey:@"blog_name"];
	self.postURL = [dictionary safeObjectForKey:@"post_url"];
	self.state = [dictionary safeObjectForKey:@"state"];
	self.format = [dictionary safeObjectForKey:@"format"];
	self.reblogKey = [dictionary safeObjectForKey:@"reblog_key"];
	self.sourceURL = [dictionary safeObjectForKey:@"source_url"];
	self.sourceTitle = [dictionary safeObjectForKey:@"source_title"];
	self.liked = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"liked"] boolValue]];
    self.createdAt = [NSDate dateWithTimeIntervalSince1970:[[dictionary safeObjectForKey:@"timestamp"] intValue]];
    
    NSString *type = [dictionary objectForKey:@"type"];
    if ([type isEqualToString:@"text"]) {
        self.type = [NSNumber numberWithEntityType:TumblrPostTypeText];
    } else if ([type isEqualToString:@"photo"]) {
        self.type = [NSNumber numberWithEntityType:TumblrPostTypePhoto];
    } else if ([type isEqualToString:@"quote"]) {
        self.type = [NSNumber numberWithEntityType:TumblrPostTypeQuote];
    } else if ([type isEqualToString:@"link"]) {
        self.type = [NSNumber numberWithEntityType:TumblrPostTypeLink];
    } else if ([type isEqualToString:@"chat"]) {
        self.type = [NSNumber numberWithEntityType:TumblrPostTypeChat];
    } else if ([type isEqualToString:@"audio"]) {
        self.type = [NSNumber numberWithEntityType:TumblrPostTypeAudio];
    } else if ([type isEqualToString:@"video"]) {
        self.type = [NSNumber numberWithEntityType:TumblrPostTypeVideo];
    } else if ([type isEqualToString:@"answer"]) {
        self.type = [NSNumber numberWithEntityType:TumblrPostTypeAnswer];
    }
    
    // TODO photoset type should be set to 2 when it is photoset
    // TODO tags
    // self.tags = [dictionary safeObjectForKey:@"tags"];
    
    // Detect Type
    switch ([self.type entityTypeValue]) {
        case TumblrPostTypeText:
            self.title = [dictionary safeObjectForKey:@"title"];
            self.body = [dictionary safeObjectForKey:@"body"];
            break;
            
        case TumblrPostTypePhoto:
        case TumblrPostTypePhotoSet:
            // TODO photos
            self.caption = [dictionary safeObjectForKey:@"caption"];
            self.width = [dictionary safeObjectForKey:@"width"];
            self.height = [dictionary safeObjectForKey:@"height"];
            break;
            
        case TumblrPostTypeQuote:
            self.text = [dictionary safeObjectForKey:@"text"];
            self.source = [dictionary safeObjectForKey:@"source"];
            break;
            
        case TumblrPostTypeLink:
            self.title = [dictionary safeObjectForKey:@"title"];
            self.url = [dictionary safeObjectForKey:@"url"];
            self.body = [dictionary safeObjectForKey:@"body"];
            break;
            
        case TumblrPostTypeChat:
            self.title = [dictionary safeObjectForKey:@"title"];
            self.body = [dictionary safeObjectForKey:@"body"];
            // TODO dialogue
            break;
            
        case TumblrPostTypeAudio:
            self.caption = [dictionary safeObjectForKey:@"caption"];
            self.url = [dictionary safeObjectForKey:@"url"];
            self.plays = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"plays"] intValue]];
            self.albumArt = [dictionary safeObjectForKey:@"album_art"];
            self.artist = [dictionary safeObjectForKey:@"artist"];
            self.album = [dictionary safeObjectForKey:@"album"];
            self.trackName = [dictionary safeObjectForKey:@"track_name"];
            self.trackNumber = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"track_number"] intValue]];
            self.year = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"year"] intValue]];
            break;
            
        case TumblrPostTypeVideo:
            self.caption = [dictionary safeObjectForKey:@"caption"];
            self.url = [dictionary safeObjectForKey:@"url"];
            break;
            
        case TumblrPostTypeAnswer:
            self.askingName = [dictionary safeObjectForKey:@"asking_name"];
            self.askingURL = [dictionary safeObjectForKey:@"asking_url"];
            self.question = [dictionary safeObjectForKey:@"question"];
            self.answer = [dictionary safeObjectForKey:@"answer"];
            break;
        
        default:
            break;
    }
}

#pragma mark - Getters

- (TumblrPostType)typeRaw
{
    return (TumblrPostType)[[self type] intValue];
}

#pragma mark - Setters

-(void)setTypeRaw:(TumblrPostType)typeRaw
{
    [self setTypeRaw:[[NSNumber numberWithInt:typeRaw] intValue]];
}

- (void)createWithSuccess:(void(^)(void))success failure:(void(^)(AFJSONRequestOperation *remoteOperation, NSError *error))failure {
    [[TumblrHTTPClient sharedClient] savePost:self forBlog:[self blog] success:^(AFJSONRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:failure];
}

@end
