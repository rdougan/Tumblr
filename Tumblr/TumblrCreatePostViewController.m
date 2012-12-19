//
//  TumblrCreatePostViewController.m
//  Tumblr
//
//  Created by Robert Dougan on 12/19/12.
//  Copyright (c) 2012 Robert Dougan. All rights reserved.
//

#import "TumblrCreatePostViewController.h"

#import "TumblrBlogsTableViewController.h"

@interface TumblrCreatePostViewController ()

@end

@implementation TumblrCreatePostViewController {
    UIPopoverController *_popoverController;
}

@synthesize blog = _blog;

- (id)init
{
    return (self = [super initWithNibName:nil bundle:nil]);
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Navigation bar items
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)]];
    
    // Navigation bar tap gesture recognizer
    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    navSingleTap.numberOfTapsRequired = 1;
    [[self.navigationController.navigationBar.subviews objectAtIndex:1] setUserInteractionEnabled:YES];
    [[self.navigationController.navigationBar.subviews objectAtIndex:1] addGestureRecognizer:navSingleTap];
    
    // Hide the popover when default blog changes
    [[NSNotificationCenter defaultCenter] addObserverForName:kTKCurrentDefaultPostBlogChangedNotificationName object:nil queue:nil usingBlock:^(NSNotification *note) {
        if ([_popoverController isPopoverVisible]) {
            [_popoverController dismissPopoverAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)navSingleTap
{
    UIView *view = [self.navigationController.navigationBar.subviews objectAtIndex:1];
    
    if (!_popoverController) {
        TumblrBlogsTableViewController *viewController = [[TumblrBlogsTableViewController alloc] init];
        _popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    }
    
    [_popoverController presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)cancel:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)done:(id)sender
{
    TKPost *post = [self post];
    TKBlog *blog = [TKBlog defaultBlog];
    
    if (!post || !blog) {
        return;
    }

    [post setBlog:blog];
    [post createWithSuccess:^{
        [self cancel:self];
    } failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
        NSLog(@"could not create the post:\n%@", error);
    }];
}

- (TKPost *)post
{
    return nil;
}

@end
