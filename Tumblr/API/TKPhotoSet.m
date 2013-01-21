//
//  TKPhotoSet.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TKPhotoSet.h"
#import "TKPhoto.h"
#import "TKPost.h"

@interface TKPhotoSet()

@property (nonatomic, retain) NSArray *sortedPhotos;

@end

@implementation TKPhotoSet {
    NSMutableDictionary *_layoutInformation;
    NSMutableDictionary *_frameInformation;
}

@dynamic attribute;
@dynamic caption;
@dynamic layout;
@dynamic photos;
@dynamic post;

@synthesize sortedPhotos = _sortedPhotos;
@synthesize firstPhoto = _firstPhoto;

- (TKPhoto *)firstPhoto
{
    if (!_firstPhoto) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [TKPhoto entityWithContext:self.managedObjectContext];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"photoSet = %@", self];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sortID" ascending:YES]];
        fetchRequest.fetchLimit = 1;
        
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        if ([results count] > 0) {
            _firstPhoto = [results objectAtIndex:0];
        }
    }
    
    return _firstPhoto;
}

- (NSArray *)sortedPhotos
{
    if (!_sortedPhotos) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [TKPhoto entityWithContext:self.managedObjectContext];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"photoSet = %@", self];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sortID" ascending:YES]];
    
        _sortedPhotos = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    }
    
    return _sortedPhotos;
}

- (NSDictionary *)layoutInformation
{
    if (!_layoutInformation) {
        _layoutInformation = [NSMutableDictionary dictionary];
    } else {
        [_layoutInformation removeAllObjects];
    }
    
    NSMutableArray *rows = [NSMutableArray array];
    NSString *layoutString = [NSString stringWithFormat:@"%@", self.layout];
    int totalCount = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    unsigned int len = [layoutString length];
    unichar buffer[len + 1];
    [layoutString getCharacters:buffer range:NSMakeRange(0, len)];
    
    for (int row = 0; row < len; ++row) {
        int rowCount = [[NSString stringWithFormat:@"%c", buffer[row]] intValue];
        CGFloat rowX = 0;
        CGFloat rowWidth = 0;
        NSMutableArray *rowPhotos = [NSMutableArray array];
        NSNumber *rowHeight = [NSNumber numberWithInt:0];
        
        for (int i = 0; i < rowCount; i++) {
            TKPhoto *photo = [[self sortedPhotos] objectAtIndex:totalCount];
            
            [rowPhotos addObject:@{
                @"width" : [photo width],
                @"height" : [photo height],
                @"x" : [NSNumber numberWithFloat:rowX],
                @"y" : [NSNumber numberWithFloat:y]
            }];
            
            rowHeight = [photo height];
            
            rowWidth = rowWidth + [[photo width] floatValue];
            
            totalCount = totalCount + 1;
            rowX = rowX + [[photo width] floatValue];
        }
        
        [rows addObject:@{
            @"photos" : rowPhotos,
            @"height" : rowHeight,
            @"width" : [NSNumber numberWithFloat:rowWidth]
        }];
        
        y = y + [rowHeight floatValue];
        width = MAX(width, rowWidth);
    }
    
    [_layoutInformation setObject:rows forKey:@"rows"];
    [_layoutInformation setObject:[NSNumber numberWithFloat:y] forKey:@"height"];
    [_layoutInformation setObject:[NSNumber numberWithFloat:width] forKey:@"width"];
    
    return (NSDictionary *)_layoutInformation;
}

- (NSDictionary *)frameInformationForWidth:(CGFloat)width spacing:(CGFloat)spacing
{
    if (!_frameInformation) {
        _frameInformation = [NSMutableDictionary dictionary];
    }
    
    NSString *key = [NSString stringWithFormat:@"%@-%@", [NSNumber numberWithFloat:width], [NSNumber numberWithFloat:spacing]];
    
    if (![_frameInformation objectForKey:key]) {
        NSMutableArray *frames = [NSMutableArray array];
        NSDictionary *layoutInformation = [self layoutInformation];
        
        __block CGFloat currentY = 0;
        
        NSArray *rows = [layoutInformation valueForKey:@"rows"];
        [rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *photos = [(NSDictionary *)obj valueForKey:@"photos"];
            CGFloat totalWidth = [[(NSDictionary *)obj valueForKey:@"width"] floatValue];
            CGFloat photoWidth = totalWidth / [photos count];
            CGFloat ratio = (width - (([photos count] - 1) * spacing)) / totalWidth;
            __block CGFloat rowHeight = 0;
            
            [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger photosIndex, BOOL *stop) {
                rowHeight = lroundf([[obj valueForKey:@"height"] floatValue] * ratio);
                
                NSDictionary *frame = @{
                    @"width" : [NSNumber numberWithFloat:lroundf(photoWidth * ratio)],
                    @"height" : [NSNumber numberWithFloat:rowHeight],
                    @"x" : [NSNumber numberWithFloat:lroundf(([[obj valueForKey:@"x"] floatValue] * ratio) + (spacing * photosIndex))],
                    @"y" : [NSNumber numberWithFloat:lroundf(currentY)]
                };
                
                [frames addObject:frame];
            }];
            
            currentY = currentY + rowHeight + spacing;
        }];
    
        [_frameInformation setObject:@{ @"frames" : (NSArray *)frames, @"height" : [NSNumber numberWithFloat:currentY - spacing] } forKey:key];
    }
    
    return [_frameInformation objectForKey:key];
}

- (CGFloat)heightForRow:(int)row
{
    return 0;
}

- (TKPhoto *)photoForRow:(int)row
{
    return nil;
}



@end
