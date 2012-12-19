//
//  TumblrUserTableViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/18/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrTableViewController.h"

#import "TumblrBlogViewController.h"
#import "TumblrDashboardViewController.h"

@interface TumblrTableViewController ()

@end

@implementation TumblrTableViewController {
    NSMutableArray *_data;
    
    UIBarButtonItem *_loginButton;
    UIBarButtonItem *_logoutButton;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:kTKCurrentUserChangedNotificationName object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self userChanged];
        }];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // Refresh button
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)]];
    
    [self userChanged];
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Authentication

- (void)userChanged
{    
    if ([TKUser currentUser]) {
        if (!_logoutButton) {
            _logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
        }
        
        [self.navigationItem setLeftBarButtonItem:_logoutButton];
        [[self.navigationItem rightBarButtonItem] setEnabled:YES];
    } else {
        if (!_loginButton) {
            _loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
        }
        
        [self.navigationItem setLeftBarButtonItem:_loginButton];
        [[self.navigationItem rightBarButtonItem] setEnabled:NO];
    }
    
    [self reloadData];
}

- (void)login:(id)sender
{
    [[TKHTTPClient sharedClient] login];
}

- (void)logout:(id)sender
{
    [[TKHTTPClient sharedClient] logout];
}

#pragma mark - Data

- (void)refresh:(id)sender
{
//    [[TumblrHTTPClient sharedClient] updateUserInfo:[User currentUser] success:^(AFJSONRequestOperation *operation, id responseObject) {
//        [self reloadData];
//    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
//        NSLog(@"Error updating user info: %@", error);
//    }];
    
    TKBlog *blog = [TKBlog objectWithRemoteID:@"thumblrapp"];
    
    TKPost *post = [[TKPost alloc] init];
    [post setTitle:@"testing"];
    [post setBody:@"well hello there"];
    [post setBlog:blog];

    [post createWithSuccess:^{
        NSLog(@"success!");
    } failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)reloadData
{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    
    [_data removeAllObjects];
    
    TKUser *user = [TKUser currentUser];
    
    if ([TKUser currentUser]) {
        [_data addObject:@{@"title" : @"Name", @"detail" : [user name]}];
        [_data addObject:@{@"title" : @"Following", @"detail" : [NSString stringWithFormat:@"%@", [user following]]}];
        [_data addObject:@{@"title" : @"Likes", @"detail" : [NSString stringWithFormat:@"%@", [user likes]]}];
        [_data addObject:@{@"title" : @"Access Token", @"detail" : [user accessToken]}];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([TKUser currentUser]) {
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([TKUser currentUser]) {
        if (section == 0) {
            return [_data count];
        } else if (section == 1) {
            return 1;
        } else {
            return [[[TKUser currentUser] blogs] count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath indexAtPosition:0];
    int row = [indexPath indexAtPosition:1];
    
    static NSString *CellIdentifier;
    if (![TKUser currentUser]) {
        CellIdentifier = @"LoggedOutRow";
    } else if (section == 0) {
        CellIdentifier = @"DataRow";
    } else {
        CellIdentifier = @"BlogsRow";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (![TKUser currentUser]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        } else if (section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    }
    
    if (section == 0) {
        NSDictionary *item = [_data objectAtIndex:row];
        
        [[cell textLabel] setText:[item objectForKey:@"title"]];
        [[cell detailTextLabel] setText:[item objectForKey:@"detail"]];
    } else if (section == 1) {
        [[cell textLabel] setText:@"Dashboard"];
    } else {
        NSArray *blogs = [[[TKUser currentUser] blogs] allObjects];
        TKBlog *item = [blogs objectAtIndex:row];
        
        [[cell textLabel] setText:[item title]];
        [[cell detailTextLabel] setText:[item remoteID]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath indexAtPosition:0] == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath indexAtPosition:0];
    if (section == 0) {
        return;
    }
    
    UITableViewController *viewController;
    if (section == 1) {
        viewController = (UITableViewController *)[[TumblrDashboardViewController alloc] initWithRemoteID:[[TKUser currentUser] remoteID]];
    } else {
        NSArray *blogs = [[[TKUser currentUser] blogs] allObjects];
        TKBlog *item = [blogs objectAtIndex:[indexPath indexAtPosition:1]];
        
        viewController = (UITableViewController *)[[TumblrBlogViewController alloc] initWithRemoteID:[item remoteID]];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (![TKUser currentUser]) {
        return @"Please login to view Tumblr content.";
    }
    return nil;
}

@end
