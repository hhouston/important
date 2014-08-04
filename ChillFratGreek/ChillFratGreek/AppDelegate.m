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
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "LogInViewController.h"
#import "ProfileObject.h"
#import "CheckLoginViewController.h"
#import "RearMasterTableViewController.h"
#import "SWRevealViewController.h"
#import "RightTableViewController.h"
#import "SlideNavigationController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// 1
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    //NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@_ProfileModel.sqlite",userID]]];
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"ProfileModel.sqlite"]];
    
    NSLog(@"Core Data store path = \"%@\"", [storeUrl path]);

    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}



- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [Parse setApplicationId:@"HIvzR0l4XsknaMMXqwjDfRbUeHKlj8l5ojHIBvcA"
                  clientKey:@"8JSNQYaHXzGHEoAUBYDGbfe6WEhehcwFCLDuEaXr"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [GMSServices provideAPIKey:@"AIzaSyAzfyaz2qzrZfOSqXutD0dYxcyGpT47Wl8"];
    
//    if ([PFUser currentUser]) {
//        NSLog(@"AppDelegate:logged in");
//        ProfileObject *userData = [[ProfileObject alloc] init];
//        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//        NSString *userID = [PFUser currentUser].objectId;
//        [query whereKey:@"objectID" equalTo:userID];
//        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//            //self.chapterID = object[@"chapterID"];
//            userData.chapterID = object[@"chapterID"];
//            userData.collegeID = object[@"collegeID"];
//            userData.userAlias = object[@"alias"];
//            userData.avatar.image = [UIImage imageNamed:@"avatar.jpg"];
//            userData.avatar.file = (PFFile *)object[@"avatar"];
//            [userData.avatar loadInBackground];
//
//
//        }];
    
    // This will get a pointer to an object that represents the app bundle
    //self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    //RightTableViewController *rightMenu = [[RightTableViewController alloc ] init];
    //[SlideNavigationController sharedInstance].rightMenu = rightMenu;

    
        
        //    // Create content and menu controllers
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:[[CheckLoginViewController alloc] init]];
        MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
        
    
    
        //    // Create frosted view controller
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
        frostedViewController.liveBlur = YES;
        frostedViewController.delegate = self;
        //
    
        //    // Make it a root controller
        //    //
        self.window.rootViewController = frostedViewController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];

//        
//    } else {
//        
//        NSLog(@"AppDelegate:not logged in");
//        //LogInViewController *lvc = (LogInViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"lvc"];
//        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"lvc"];
//        
//    }






    return YES;
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
-(NSArray*)getProfiles
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedProfiles = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedProfiles;
}
@end
