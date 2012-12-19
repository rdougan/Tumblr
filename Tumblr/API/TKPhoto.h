//
//  TKPhoto.h
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TKPhotoSet;

@interface TKPhoto : SSRemoteManagedObject

@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSNumber *width;
@property (nonatomic, retain) TKPhotoSet *photoSet;

@end
