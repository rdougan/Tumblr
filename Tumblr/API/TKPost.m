//
//  Post.m
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TKPost.h"
#import "TKBlog.h"

@implementation TKPost

@dynamic type;
@dynamic blogName;
@dynamic postURL;
@dynamic format;
@dynamic reblogKey;
@dynamic tags;
@dynamic sourceURL;
@dynamic sourceTitle;
@dynamic state;
@dynamic liked;
@dynamic createdAt;

@dynamic blog;
@dynamic user;
@dynamic dashboardUser;
@dynamic likedUser;

@dynamic rebloggedFromId;
@dynamic rebloggedFromName;
@dynamic rebloggedFromTitle;
@dynamic rebloggedFromURL;
@dynamic rebloggedRootName;
@dynamic rebloggedRootTitle;
@dynamic rebloggedRootURL;

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
    
    // Reblogged information
	self.rebloggedFromId = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"reblogged_from_id"] intValue]];
	self.rebloggedFromName = [dictionary safeObjectForKey:@"reblogged_from_name"];
	self.rebloggedFromTitle = [dictionary safeObjectForKey:@"reblogged_from_title"];
	self.rebloggedFromURL = [dictionary safeObjectForKey:@"reblogged_from_url"];
	self.rebloggedRootName = [dictionary safeObjectForKey:@"reblogged_root_name"];
	self.rebloggedRootTitle = [dictionary safeObjectForKey:@"reblogged_root_title"];
	self.rebloggedRootURL = [dictionary safeObjectForKey:@"reblogged_root_url"];
    
    NSString *type = [dictionary objectForKey:@"type"];
    if ([type isEqualToString:@"text"]) {
        self.type = [NSNumber numberWithEntityType:TKPostTypeText];
    } else if ([type isEqualToString:@"photo"]) {
        self.type = [NSNumber numberWithEntityType:TKPostTypePhoto];
    } else if ([type isEqualToString:@"quote"]) {
        self.type = [NSNumber numberWithEntityType:TKPostTypeQuote];
    } else if ([type isEqualToString:@"link"]) {
        self.type = [NSNumber numberWithEntityType:TKPostTypeLink];
    } else if ([type isEqualToString:@"chat"]) {
        self.type = [NSNumber numberWithEntityType:TKPostTypeChat];
    } else if ([type isEqualToString:@"audio"]) {
        self.type = [NSNumber numberWithEntityType:TKPostTypeAudio];
    } else if ([type isEqualToString:@"video"]) {
        self.type = [NSNumber numberWithEntityType:TKPostTypeVideo];
    } else if ([type isEqualToString:@"answer"]) {
        self.type = [NSNumber numberWithEntityType:TKPostTypeAnswer];
    }
    
    // TODO photoset type should be set to 2 when it is photoset
    // TODO tags
    // self.tags = [dictionary safeObjectForKey:@"tags"];
    
    // Detect Type
    switch ([self.type entityTypeValue]) {
        case TKPostTypeText:
        {
            self.title = [dictionary safeObjectForKey:@"title"];
            self.body = [dictionary safeObjectForKey:@"body"];
        }
        break;
            
        case TKPostTypePhoto:
        case TKPostTypePhotoSet:
        {
            // TODO photos
            self.caption = [dictionary safeObjectForKey:@"caption"];
            self.width = [dictionary safeObjectForKey:@"width"];
            self.height = [dictionary safeObjectForKey:@"height"];
        }
        break;
            
        case TKPostTypeQuote:
        {
            self.text = [dictionary safeObjectForKey:@"text"];
            self.source = [dictionary safeObjectForKey:@"source"];
        }
        break;
            
        case TKPostTypeLink:
        {
            self.title = [dictionary safeObjectForKey:@"title"];
            self.url = [dictionary safeObjectForKey:@"url"];
            self.body = [dictionary safeObjectForKey:@"body"];
        }
        break;
            
        case TKPostTypeChat:
        {
            self.title = [dictionary safeObjectForKey:@"title"];
            self.body = [dictionary safeObjectForKey:@"body"];
            
            [self setDialogue:nil];
            
            NSArray *dialogue = [dictionary valueForKeyPath:@"dialogue"];
            for (NSDictionary *chatDictionary in dialogue) {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:chatDictionary];
                [dictionary setObject:[NSString stringWithFormat:@"%i", [dialogue indexOfObject:chatDictionary]] forKey:@"remoteID"];
				TKChat *chat = [TKChat objectWithDictionary:chatDictionary];
				chat.post = self;
			}
        }
        break;
            
        case TKPostTypeAudio:
        {
            self.caption = [dictionary safeObjectForKey:@"caption"];
            self.url = [dictionary safeObjectForKey:@"url"];
            self.plays = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"plays"] intValue]];
            self.albumArt = [dictionary safeObjectForKey:@"album_art"];
            self.artist = [dictionary safeObjectForKey:@"artist"];
            self.album = [dictionary safeObjectForKey:@"album"];
            self.trackName = [dictionary safeObjectForKey:@"track_name"];
            self.trackNumber = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"track_number"] intValue]];
            self.year = [NSNumber numberWithInt:[[dictionary safeObjectForKey:@"year"] intValue]];
        }
        break;
            
        case TKPostTypeVideo:
        {
            self.caption = [dictionary safeObjectForKey:@"caption"];
            self.url = [dictionary safeObjectForKey:@"url"];
        }
        break;
            
        case TKPostTypeAnswer:
        {
            self.askingName = [dictionary safeObjectForKey:@"asking_name"];
            self.askingURL = [dictionary safeObjectForKey:@"asking_url"];
            self.question = [dictionary safeObjectForKey:@"question"];
            self.answer = [dictionary safeObjectForKey:@"answer"];
        }
        break;
        
        default:
        break;
    }
}

- (BOOL)isReblogged
{
    return (self.rebloggedFromName && ![self.rebloggedFromName isEqualToString:@""]);
}

#pragma mark - Getters

- (TKPostType)typeRaw
{
    return (TKPostType)[[self type] intValue];
}

#pragma mark - Setters

-(void)setTypeRaw:(TKPostType)typeRaw
{
    [self setTypeRaw:[[NSNumber numberWithInt:typeRaw] intValue]];
}

- (void)createWithSuccess:(void(^)(void))success failure:(void(^)(AFJSONRequestOperation *remoteOperation, NSError *error))failure {
    [[TKHTTPClient sharedClient] savePost:self forBlog:[self blog] success:^(AFJSONRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:failure];
}

@end
