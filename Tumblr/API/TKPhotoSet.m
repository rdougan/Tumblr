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
    
    NSArray *sortedPhotos = [self sortedPhotos];
    int sortedPhotosCount = [[self sortedPhotos] count];
    NSMutableArray *rows = [NSMutableArray array];
    NSString *layoutString = [NSString stringWithFormat:@"%@", self.layout];
    int totalCount = 0;
    int totalLayoutCount = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    BOOL layoutPossible = YES;
    unsigned int len = [layoutString length];
    unichar buffer[len + 1];
    [layoutString getCharacters:buffer range:NSMakeRange(0, len)];
    
    // If the total number of photoset photos required for this layout is more than the actual photo count,
    // we can't lay it out properly
    // This exists for the following post:
    //   http://el-amor-de-tu-dia.tumblr.com/post/41262495464/diggydre-best-dad-everr
    // Layout is 27591, which is a total of 24 photos - but we only have 9 photos.
    // fuck knows why.
    for (int row = 0; row < len; ++row) {
        int rowCount = [[NSString stringWithFormat:@"%c", buffer[row]] intValue];
        totalLayoutCount = totalLayoutCount + rowCount;
    }
    
    if (totalLayoutCount > sortedPhotosCount) {
        layoutPossible = NO;
    }
    
    // If we can do the layout, do it.
    if (layoutPossible) {
        for (int row = 0; row < len; ++row) {
            int rowCount = [[NSString stringWithFormat:@"%c", buffer[row]] intValue];
            CGFloat rowX = 0;
            CGFloat rowWidth = 0;
            NSMutableArray *rowPhotos = [NSMutableArray array];
            NSNumber *rowHeight = [NSNumber numberWithInt:0];
            
            for (int i = 0; i < rowCount; i++) {
                TKPhoto *photo = [sortedPhotos objectAtIndex:totalCount];
                
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
    } else {
        // if not, just lay them out the full width
        for (int i = 0; i < sortedPhotosCount; i++) {
            NSMutableArray *rowPhotos = [NSMutableArray array];
            TKPhoto *photo = [sortedPhotos objectAtIndex:i];
            NSNumber *rowHeight = [photo height];
            NSNumber *rowWidth = [photo width];
            
            [rowPhotos addObject:@{
                @"width" : [photo width],
                @"height" : [photo height],
                @"x" : [NSNumber numberWithInt:0],
                @"y" : [NSNumber numberWithFloat:y]
            }];
            
            [rows addObject:@{
                @"photos" : rowPhotos,
                @"height" : rowHeight,
                @"width" : rowWidth
            }];
            
            y = y + [rowHeight floatValue];
        }
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
