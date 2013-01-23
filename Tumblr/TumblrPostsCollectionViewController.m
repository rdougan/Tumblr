//
//  TumblrPostsCollectionViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPostsCollectionViewController.h"

#import "TumblrPostCollectionViewCell.h"
#import "TumblrTextPostCollectionViewCell.h"
#import "TumblrQuotePostCollectionViewCell.h"
#import "TumblrVideoPostCollectionViewCell.h"
#import "TumblrPhotoPostCollectionViewCell.h"
#import "TumblrPhotoSetPostCollectionViewCell.h"

@interface TumblrPostsCollectionViewController ()

@end

@implementation TumblrPostsCollectionViewController

- (id)init {
	if ((self = [super initWithLayout:[[UICollectionViewFlowLayout alloc] init]])) {
		
	}
	return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
    // Collection view cell classes
    [self.collectionView registerClass:[TumblrTextPostCollectionViewCell class] forCellWithReuseIdentifier:@"CellText"];
    [self.collectionView registerClass:[TumblrPhotoPostCollectionViewCell class] forCellWithReuseIdentifier:@"CellPhoto"];
    [self.collectionView registerClass:[TumblrPhotoSetPostCollectionViewCell class] forCellWithReuseIdentifier:@"CellPhotoset"];
    [self.collectionView registerClass:[TumblrQuotePostCollectionViewCell class] forCellWithReuseIdentifier:@"CellQuote"];
    [self.collectionView registerClass:[TumblrPostCollectionViewCell class] forCellWithReuseIdentifier:@"CellLink"];
    [self.collectionView registerClass:[TumblrPostCollectionViewCell class] forCellWithReuseIdentifier:@"CellChat"];
    [self.collectionView registerClass:[TumblrPostCollectionViewCell class] forCellWithReuseIdentifier:@"CellAudio"];
    [self.collectionView registerClass:[TumblrPostCollectionViewCell class] forCellWithReuseIdentifier:@"CellVideo"];
    [self.collectionView registerClass:[TumblrPostCollectionViewCell class] forCellWithReuseIdentifier:@"CellAnswer"];
    
    // Refresh button
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Resource Loading

- (void)refresh:(id)sender
{
    [self fetchPostsWithOffset:0];
}

- (int)totalCount
{
    return 0;
}

- (void)fetchPosts
{
    
}

- (void)fetchPostsWithOffset:(int)offset
{
    if (self.loadingPosts) {
        return;
    }
    
    self.loadOffset = offset;
    self.loadingPosts = YES;
    
    if (self.loadOffset >= [self totalCount]) {
        return;
    }
    
    [self fetchPosts];
}

- (void)checkAndLoadMoreIfNeeded
{
    CGFloat actualPosition = self.collectionView.contentOffset.y;
    CGFloat frameHeight = self.collectionView.frame.size.height;
    CGFloat contentHeight = self.collectionView.contentSize.height;
    
    CGFloat difference = contentHeight - actualPosition - frameHeight;
    
    if ((frameHeight * 2) > difference) {
        // Figure out the last rows offset
        int numberOfRows = [self.collectionView numberOfItemsInSection:0];
        [self fetchPostsWithOffset:numberOfRows];
    }
}

- (CGFloat)cellHeightForPost:(TKPost *)post
{
    switch ([[post type] entityTypeValue]) {
        case TKPostTypeQuote:
            return [TumblrQuotePostCollectionViewCell heightForPost:post];
            break;
            
        case TKPostTypePhoto:
            return [TumblrPhotoPostCollectionViewCell heightForPost:post];
            break;
        
        case TKPostTypePhotoSet:
            return [TumblrPhotoSetPostCollectionViewCell heightForPost:post];
            break;
            
        default:
            break;
    }
    
    return [TumblrTextPostCollectionViewCell heightForPost:post];
}

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [TKPost class];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self checkAndLoadMoreIfNeeded];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self checkAndLoadMoreIfNeeded];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TKPost *post = [self objectForViewIndexPath:indexPath];
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%@", [[[post type] stringTypeValue] capitalizedString]];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [(TumblrPostCollectionViewCell *)cell setPost:post];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell && [cell respondsToSelector:@selector(didEndDisplaying)]) {
        [cell performSelector:@selector(didEndDisplaying)];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    TKPost *post = [self objectForViewIndexPath:indexPath];
    
    // TODO put this back when in production
    
//    NSNumber *cachedHeight = [post cellHeight];
//    if (!cachedHeight || [cachedHeight isEqualToNumber:[NSNumber numberWithFloat:0]]) {
        height = [self cellHeightForPost:post];
//        [post setCellHeight:[NSNumber numberWithFloat:height]];
//    } else {
//        height = [cachedHeight floatValue];
//    }
    
    return CGSizeMake(600.0, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
}

@end
