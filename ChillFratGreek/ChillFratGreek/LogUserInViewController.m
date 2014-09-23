//
//  LogUserInViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 8/12/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "LogUserInViewController.h"
#import "ProfileObject.h"
#import "NavigationController.h"
#import "MenuViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
//#import "ChatViewController.h"
#import "ChatTableViewController.h"

@interface LogUserInViewController ()

@end

@implementation LogUserInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    NSString *userID = [PFUser currentUser].objectId;
    [query whereKey:@"objectID" equalTo:[PFUser currentUser].objectId];
    
    [query getObjectInBackgroundWithId:userID block:^(PFObject *object, NSError *error) {
//        ProfileObject *userProfile = [[ProfileObject alloc] init];
//        userProfile.chapterID = object[@"chapterID"];
//        userProfile.collegeID = object[@"collegeID"];
//        userProfile.userAlias = object[@"alias"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:object[@"chapterID"] forKey:@"chapterID"];
        [defaults setObject:object[@"collegeID"] forKey:@"collegeID"];
        [defaults setObject:object[@"alias"] forKey:@"alias"];
        [defaults synchronize];
        
        AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ad.window.rootViewController = [[UIViewController alloc] init];
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:[[ChatTableViewController alloc] init]];
        MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //    // Create frosted view controller
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
        frostedViewController.liveBlur = YES;
        frostedViewController.delegate = ad.self;
        
        //    // Make it a root controller
        ad.window.rootViewController = frostedViewController;
        ad.window.backgroundColor = [UIColor whiteColor];
        [ad.window makeKeyAndVisible];
    }];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        //self.chapterID = object[@"chapterID"];
//        ProfileObject *userProfile = [[ProfileObject alloc] init];
//        userProfile.chapterID = object[@"chapterID"];
//        userProfile.collegeID = object[@"collegeID"];
//        userProfile.userAlias = object[@"alias"];
//        //userProfile.avatar.image = [UIImage imageNamed:@"avatar.jpg"];
//        //userProfile.avatar.file = (PFFile *)object[@"avatar"];
//        //[userProfile.avatar loadInBackground];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:userProfile forKey:@"userProfile"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }];
    

    // Do any additional setup after loading the view from its nib.
}

- (void)setupActivityIndicator {
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
