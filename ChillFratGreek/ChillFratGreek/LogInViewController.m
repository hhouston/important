//
//  LogInViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "LogInViewController.h"
#import "HomeViewController.h"
#import "SignUpViewController.h"
#import "NavigationController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "ProfileObject.h"
#import <Parse/Parse.h>
#import "CheckLoginViewController.h"

@interface LogInViewController ()
@property (nonatomic,strong)NSArray* fetchedProfilesArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation LogInViewController {
    HomeViewController *hvc;
    SignUpViewController *svc;
    CheckLoginViewController *clvc;
    NSString *string;
    NSString *alias;
}

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
    NSLog(@"lvc shown");

    // Do any additional setup after loading the view.
}    

- (IBAction)LogIn:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.username.text password:self.passcode.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"log in successful");
            

            alias = [[NSString alloc]init];
            self.fetchedProfilesArray = [[NSArray alloc] init];
            
            AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            self.fetchedProfilesArray = [appDelegate getProfiles];
            
            NSManagedObject *profile = nil;
            NSUInteger count = [self.fetchedProfilesArray count];
            NSLog(@"count: %lu",(unsigned long)count);
            
            if (count == 1) {
                
                profile = self.fetchedProfilesArray[count-1];
                alias = [profile valueForKey:@"alias"];
                self.chapterID = [profile valueForKey:@"chapterID"];
                NSLog(@"1 profile in Core Data, alias:%@-----%@",alias,self.chapterID);
                hvc.alias = alias;
                hvc.chapterID = self.chapterID;
            } else if (count == 0) {
                NSString *userID = [PFUser currentUser].objectId;
                //NSLog(@"USERID:%@",userID);
                NSLog(@"No profile in Core Data...loading from Parse with userID:%@",userID);
                PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                PFObject *object = [query getObjectWithId:userID];
                
                
                
                //[query getObjectInBackgroundWithId:userID block:^(PFObject *object, NSError *error) {
                    // Do something with the returned PFObject in the gameScore variable.
                    NSLog(@"%@", object);
                //}];
                    alias = object[@"alias"];
                    self.chapterID = object[@"chapterID"];
                    
                    [self saveProfile];
                    
                    hvc.chapterID = self.chapterID;
                    hvc.alias = alias;
                    NSLog(@"alias:%@\nchapterID:%@",alias,self.chapterID);
                //}];


            } else {
                NSLog(@"ERROR: more than one profile in Core Data");

            }
            //NSLog(@"alias: %@\nchapterID:%@", alias, self.chapterID);
            

            


            
            AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            ad.window.rootViewController = [[UIViewController alloc] init];
            
            NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
            MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
            //    // Create frosted view controller
            //    //
            REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
            frostedViewController.direction = REFrostedViewControllerDirectionLeft;
            frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
            frostedViewController.liveBlur = YES;
            frostedViewController.delegate = ad.self;
            //
            //    // Make it a root controller
            //    //
            ad.self.window.rootViewController = frostedViewController;
            ad.self.window.backgroundColor = [UIColor whiteColor];
            [ad.self.window makeKeyAndVisible];



//            hvc = [[HomeViewController alloc] init];
//            hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"hvc"];
//            [self presentViewController:hvc animated:YES completion:nil];
//            NSLog(@"show hvc");
        }
    }];
//    
//    hvc = [[HomeViewController alloc] init];
//    NSLog(@"show hvc");
//    //[self.navigationController pushViewController:hvc animated:YES];
//    //HomeViewController *homeViewController = [[HomeViewController alloc] init];
//    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:hvc];
//    self.frostedViewController.contentViewController = navigationController;
}

- (IBAction)SignUp:(id)sender {
    svc = [[SignUpViewController alloc] init];
    svc = [self.storyboard instantiateViewControllerWithIdentifier:@"svc"];
    [self presentViewController:svc animated:YES completion:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.passcode isFirstResponder] && [touch view] != self.passcode) {
        [self.passcode resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveProfile {
    NSLog(@"save profile called: %@", alias);
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    ProfileObject* profileEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Profile"
                                                                inManagedObjectContext:self.managedObjectContext];
    
    
    
    //NSManagedObjectContext *context = [appDelegate managedObjectContext];
    //NSManagedObject *profile;
    //profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
    [profileEntry setValue:alias forKey:@"alias"];
    [profileEntry setValue:self.chapterID forKey:@"chapterID"];
    NSError *error;
    [self.managedObjectContext save:&error];
    NSLog(@"profileEntry:%@",profileEntry);
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
