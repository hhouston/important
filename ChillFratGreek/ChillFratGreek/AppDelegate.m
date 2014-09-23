//
//  AppDelegate.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
#import "NavigationController.h"
#import "MenuViewController.h"
#import "HomeViewController.h"
#import "LogUserInViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [Parse setApplicationId:@"HIvzR0l4XsknaMMXqwjDfRbUeHKlj8l5ojHIBvcA"
                  clientKey:@"8JSNQYaHXzGHEoAUBYDGbfe6WEhehcwFCLDuEaXr"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [GMSServices provideAPIKey:@"AIzaSyAzfyaz2qzrZfOSqXutD0dYxcyGpT47Wl8"];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    
    if ([PFUser currentUser]) {
        
        NSLog(@"AppDelegate:logged in");
        
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:[[LogUserInViewController alloc] init]];
        MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //    // Create frosted view controller
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
        frostedViewController.liveBlur = YES;
        frostedViewController.delegate = self;
            
        //    // Make it a root controller
        self.window.rootViewController = frostedViewController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    } else {
        //LogInViewController *lvc = (LogInViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"lvc"];
        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"lvc"];
    }

    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    //PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    //[currentInstallation setDeviceTokenFromData:deviceToken];
    
    //currentInstallation.channels = @[@"global"];
    //[currentInstallation saveInBackground];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"user info%@",userInfo);
    
    [PFPush handlePush:userInfo];
}
- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController");
}



@end
