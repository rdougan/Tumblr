//
//  TKChat.h
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TKPost;

@interface TKChat : SSRemoteManagedObject

@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phrase;
@property (nonatomic, retain) NSString *remoteID;
@property (nonatomic, retain) TKPost *post;

@end
