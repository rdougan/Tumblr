//
//  Post.h
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TKBlog;
@class Photo;

@interface TKPost : SSRemoteManagedObject

@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSString *blogName;
@property (nonatomic, retain) NSString *postURL;
@property (nonatomic, retain) NSString *format;
@property (nonatomic, retain) NSString *reblogKey;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, retain) NSString *sourceURL;
@property (nonatomic, retain) NSString *sourceTitle;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSNumber *liked;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) TKBlog *blog;
@property (nonatomic, retain) TKUser *user;

// Text
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;

// Photo/PhotoSet
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSNumber *width;
@property (nonatomic, retain) NSNumber *height;

// Quote
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *source;

// Link
// - title
@property (nonatomic, retain) NSString *url;
// - body

// Chat
// - title
// - body
@property (nonatomic, retain) NSSet *dialogue;

// Audio
// - caption
// - url
@property (nonatomic, retain) NSNumber *plays;
@property (nonatomic, retain) NSString *albumArt;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *album;
@property (nonatomic, retain) NSString *trackName;
@property (nonatomic, retain) NSNumber *trackNumber;
@property (nonatomic, retain) NSNumber *year;

// Video
// - caption
// - url

// Answer
@property (nonatomic, retain) NSString *askingName;
@property (nonatomic, retain) NSString *askingURL;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;

- (void)createWithSuccess:(void(^)(void))success failure:(void(^)(AFJSONRequestOperation *remoteOperation, NSError *error))failure;

@end
