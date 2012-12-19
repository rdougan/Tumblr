//
//  TumblrBlogsTableViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrBlogsTableViewController.h"

@interface TumblrBlogsTableViewController ()

@end

@implementation TumblrBlogsTableViewController

- (id)init
{
    return (self = [super initWithStyle:UITableViewStylePlain]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self restoreDefaultBlog];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Selected Blog

- (void)restoreDefaultBlog
{
    TKBlog *defaultBlog = [TKBlog defaultBlog];
    
    if (!defaultBlog) {
        defaultBlog = [self objectForViewIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [TKBlog setDefaultBlog:defaultBlog];
    }
    
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:defaultBlog];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [TKBlog class];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKBlog *blog = [self objectForViewIndexPath:indexPath];
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [[cell textLabel] setText:[blog title]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKBlog *defaultBlog = [self objectForViewIndexPath:indexPath];
    [TKBlog setDefaultBlog:defaultBlog];
}

@end
