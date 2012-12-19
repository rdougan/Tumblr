//
//  TumblrPostsViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrPostsViewController.h"

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
	return [Post class];
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
    Post *post = [self objectForViewIndexPath:indexPath];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"PostCell%@", [post type]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    switch ([[post type] entityTypeValue]) {
        case TumblrPostTypeText:
            [[cell textLabel] setText:[post title]];
            [[cell detailTextLabel] setText:@"Text"];
            break;
            
        case TumblrPostTypePhoto:
            [[cell textLabel] setText:[post caption]];
            [[cell detailTextLabel] setText:@"Photo"];
            break;
            
        case TumblrPostTypePhotoSet:
            [[cell detailTextLabel] setText:@"PhotoSet"];
            break;
            
        case TumblrPostTypeQuote:
            [[cell textLabel] setText:[post text]];
            [[cell detailTextLabel] setText:@"Quote"];
            break;
            
        case TumblrPostTypeLink:
            [[cell detailTextLabel] setText:@"Link"];
            break;
            
        case TumblrPostTypeChat:
            [[cell detailTextLabel] setText:@"Chat"];
            break;
            
        case TumblrPostTypeAudio:
            [[cell detailTextLabel] setText:@"Audio"];
            break;
            
        case TumblrPostTypeVideo:
            [[cell detailTextLabel] setText:@"Video"];
            break;
            
        case TumblrPostTypeAnswer:
            [[cell detailTextLabel] setText:@"Answer"];
            break;
            
        default:
            break;
    }
    
    //    [[cell detailTextLabel] setText:[[post createdAt] description]];
    
    return cell;
}

@end
