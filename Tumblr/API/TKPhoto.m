//
//  TKPhoto.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TKPhoto.h"

@implementation TKPhoto

@dynamic sortID;
@dynamic height;
@dynamic url;
@dynamic width;
@dynamic caption;
@dynamic photoSet;
@dynamic sizes;

+ (NSString *)remoteIDField
{
    return @"sortID";
}

+ (NSArray *)defaultSortDescriptors {
	return [NSArray arrayWithObjects:
			[NSSortDescriptor sortDescriptorWithKey:@"sortID" ascending:NO],
			nil];
}

- (NSArray *)sortedSizes
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [TKPhotoSize entityWithContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"photo = %@", self];
	fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"width" ascending:YES]];
	return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (TKPhotoSize *)closestSizeForWidth:(CGFloat)width
{
    NSMutableArray *sizes = [NSMutableArray arrayWithArray:[self sortedSizes]];
    
    TKPhotoSize *original = [[TKPhotoSize alloc] init];
    original.url = self.url;
    original.width = self.width;
    original.height = self.height;
    
    [sizes addObject:original];
    
    __block TKPhotoSize *size = nil;
    
    [sizes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[(TKPhotoSize *)size width] floatValue] > width) {
            *stop = YES;
        }
        
        size = (TKPhotoSize *)obj;
    }];
    
    return size;
}

@end
