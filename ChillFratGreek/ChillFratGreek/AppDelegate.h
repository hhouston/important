//
//  AppDelegate.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "SWRevealViewController/SWRevealViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, REFrostedViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboard;

@end
