//
//  TKPhotoSize.h
//  Tumblr
//
//  Created by Robert Dougan on 12/23/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TKPhoto;

@interface TKPhotoSize : SSRemoteManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) TKPhoto *photo;

@end
