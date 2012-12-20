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
#import "TumblrLikesViewController.h"

#import "TumblrCreatePostViewController.h"
#import "TumblrCreateTextPostViewController.h"

@interface TumblrTableViewController ()

@end

@implementation TumblrTableViewController {
    NSMutableArray *_data;
    NSArray *_blogsArray;
    
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
    [[TKHTTPClient sharedClient] updateUserInfo:[TKUser currentUser] success:^(AFJSONRequestOperation *operation, id responseObject) {
        [self reloadData];
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        NSLog(@"Error updating user info: %@", error);
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
        [_data addObject:@{@"title" : @"Following", @"detail" : [NSString stringWithFormat:@"%@", [user followingCount]]}];
        [_data addObject:@{@"title" : @"Likes", @"detail" : [NSString stringWithFormat:@"%@", [user likesCount]]}];
        [_data addObject:@{@"title" : @"Access Token", @"detail" : [user accessToken]}];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"url" ascending:YES];
        _blogsArray = [[[[TKUser currentUser] blogs] allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    } else {
        _blogsArray = [NSArray array];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([TKUser currentUser]) {
        return 4;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([TKUser currentUser]) {
        if (section == 0) {
            return [_data count];
        } else if (section == 1) {
            return 2;
        } else if (section == 2) {
            return [_blogsArray count];
        } else if (section == 3) {
            return 8;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath indexAtPosition:0];
    int row = [indexPath indexAtPosition:1];
    
    static NSString *CellIdentifier;
    if (![TKUser currentUser] || section == 3) {
        CellIdentifier = @"LoggedOutRow";
    } else if (section == 0) {
        CellIdentifier = @"DataRow";
    } else {
        CellIdentifier = @"BlogsRow";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (![TKUser currentUser] || section == 3) {
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
        switch (row) {
            case 0:
                [[cell textLabel] setText:@"Dashboard"];
                break;
            
            case 1:
                [[cell textLabel] setText:@"Likes"];
                break;
                
            default:
                break;
        }
    } else if (section == 2) {
        TKBlog *item = [_blogsArray objectAtIndex:row];
        
        [[cell textLabel] setText:[item title]];
        [[cell detailTextLabel] setText:[item remoteID]];
    } else if (section == 3) {
        [[cell textLabel] setText:[[NSNumber numberWithInt:row] stringTypeValue]];
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
    
    int row = [indexPath indexAtPosition:1];
    
    UIViewController *viewController;
    if (section == 1) {
        switch (row) {
            case 0:
                viewController = (UIViewController *)[[TumblrDashboardViewController alloc] initWithRemoteID:[[TKUser currentUser] remoteID]];
                break;
            
            case 1:
                viewController = (UIViewController *)[[TumblrLikesViewController alloc] initWithRemoteID:[[TKUser currentUser] remoteID]];
                break;
                
            default:
                break;
        }
    } else if (section == 2) {
        TKBlog *item = [_blogsArray objectAtIndex:row];
        
        viewController = (UIViewController *)[[TumblrBlogViewController alloc] initWithRemoteID:[item remoteID]];
    } else if (section == 3) {
        NSString *type = [[NSNumber numberWithInt:row] stringTypeValue];
        NSString *className = [NSString stringWithFormat:@"TumblrCreate%@PostViewController", [type capitalizedString]];
        
        viewController = (UIViewController *)[[NSClassFromString(className) alloc] init];
    }
    
    if (!viewController) {
        return;
    }
    
    if (section == 3) {
        UINavigationController *createNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [createNavigationController setModalPresentationStyle:UIModalPresentationFormSheet];
        [self.navigationController presentViewController:createNavigationController animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![TKUser currentUser]) {
        return @"";
    }
    
    switch (section) {
        case 0:
            return @"User Information";
            break;
            
        case 2:
            return @"User Blogs";
            break;
            
        case 3:
            return @"Create a new post";
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (![TKUser currentUser]) {
        return @"Please login to view Tumblr content.";
    }
    return nil;
}

@end
