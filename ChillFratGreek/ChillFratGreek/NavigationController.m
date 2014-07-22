//
//  NavigationController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/7/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "NavigationController.h"
#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"


@interface NavigationController ()

@property (strong, readwrite, nonatomic) MenuViewController *menuViewController;

@end

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
      //clear nav bar
//    [self.navigationBar setBackgroundImage:[UIImage new]
//                             forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.shadowImage = [UIImage new];
//    self.navigationBar.translucent = YES;
//    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
