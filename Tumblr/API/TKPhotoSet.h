//
//  TKPhotoSet.h
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TKPhoto, TKPost;

@interface TKPhotoSet : SSRemoteManagedObject

@property (nonatomic, retain) NSString *attribute;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) TKPost *post;
@end

@interface TKPhotoSet (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(TKPhoto *)value;
- (void)removePhotosObject:(TKPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
