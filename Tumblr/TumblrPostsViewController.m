//
//  TumblrPostsViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPostsViewController.h"

#import "TumblrPostCell.h"
#import "TumblrPostTextCell.h"

@interface TumblrPostsViewController ()

@end

@implementation TumblrPostsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.loadingPosts = NO;
        self.loadOffset = 0;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    // Refresh button
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)]];
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
    CGFloat actualPosition = self.tableView.contentOffset.y;
    CGFloat frameHeight = self.tableView.frame.size.height;
    CGFloat contentHeight = self.tableView.contentSize.height;
    
    CGFloat difference = contentHeight - actualPosition - frameHeight;
    
    if ((frameHeight * 2) > difference) {
        // Figure out the last rows offset
        int numberOfRows = [self.tableView numberOfRowsInSection:0];
        [self fetchPostsWithOffset:numberOfRows];
    }
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

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKPost *post = [self objectForViewIndexPath:indexPath];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"PostCell%@", [post type]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [self cellForPostType:[[post type] entityTypeValue] reuseIdentifier:CellIdentifier];
    }
    
    switch ([[post type] entityTypeValue]) {
        case TKPostTypeText:
            [[cell textLabel] setText:[post title]];
            [[cell detailTextLabel] setText:@"Text"];
            break;
            
        case TKPostTypePhoto:
            [[cell textLabel] setText:[post caption]];
            [[cell detailTextLabel] setText:@"Photo"];
            break;
            
        case TKPostTypePhotoSet:
            [[cell detailTextLabel] setText:@"PhotoSet"];
            break;
            
        case TKPostTypeQuote:
            [[cell textLabel] setText:[post text]];
            [[cell detailTextLabel] setText:@"Quote"];
            break;
            
        case TKPostTypeLink:
            [[cell detailTextLabel] setText:@"Link"];
            break;
            
        case TKPostTypeChat:
            [[cell detailTextLabel] setText:@"Chat"];
            
            NSLog(@"post:\n%i", [[post dialogue] count]);
            
            break;
            
        case TKPostTypeAudio:
            [[cell detailTextLabel] setText:@"Audio"];
            break;
            
        case TKPostTypeVideo:
            [[cell detailTextLabel] setText:@"Video"];
            break;
            
        case TKPostTypeAnswer:
            [[cell detailTextLabel] setText:@"Answer"];
            break;
            
        default:
            break;
    }
    
    //    [[cell detailTextLabel] setText:[[post createdAt] description]];
    
    return cell;
}

- (UITableViewCell *)cellForPostType:(TKPostType)type reuseIdentifier:(NSString *)reuseIdentifier
{
    switch (type) {
        case TKPostTypeText:
            return [[TumblrPostTextCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        case TKPostTypePhoto:
            return [[TumblrPostCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        case TKPostTypePhotoSet:
            return [[TumblrPostCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        case TKPostTypeQuote:
            return [[TumblrPostCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        case TKPostTypeLink:
            return [[TumblrPostCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        case TKPostTypeChat:
            return [[TumblrPostCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        case TKPostTypeAudio:
            return [[TumblrPostCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        case TKPostTypeVideo:
            return [[TumblrPostCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        case TKPostTypeAnswer:
            return [[TumblrPostCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TumblrPostCell *cell = (TumblrPostCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//    if (cell) {
//        return [cell height];
//    }
//    
//    return 44.0;
//}

@end
