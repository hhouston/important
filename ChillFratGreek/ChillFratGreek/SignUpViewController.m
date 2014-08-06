//
//  SignUpViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "SignUpViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "NavigationController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "ProfileObject.h"

@interface SignUpViewController ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation SignUpViewController

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
    // Do any additional setup after loading the view.
}
- (void)signUpAction:(id)sender {
    
    NSLog(@"registering...");
    self.alias = self.username.text;
    //self.chapterID = self.chapterCode.text;
    self.chapterID = @"pyF467c6Oc";
    PFUser *newUser = [PFUser user];
    newUser.username = self.alias;
    newUser.password = self.passcode.text;
    newUser.email = self.email.text;
    
    
    // other fields can be set if you want to save more information

    newUser[@"verification"] = self.chapterID;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"register successful");
            
            [self saveProfile];
            
            HomeViewController *hvc = [[HomeViewController alloc] init];
            AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            ad.window.rootViewController = [[UIViewController alloc] init];
            
            NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:hvc];
            MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
            //    // Create frosted view controller
            //    //
            REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
            frostedViewController.direction = REFrostedViewControllerDirectionLeft;
            frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
            frostedViewController.liveBlur = YES;
            frostedViewController.delegate = ad.self;
            
            hvc.chapterID = self.chapterID;
            hvc.alias = self.alias;
            
            //    // Make it a root controller
            //    //
            ad.self.window.rootViewController = frostedViewController;
            ad.self.window.backgroundColor = [UIColor whiteColor];
            [ad.self.window makeKeyAndVisible];

            //HomeViewController *hvc = [[HomeViewController alloc] init];
            //[self.navigationController pushViewController:hvc animated:YES];
        } else {
            NSLog(@"could not register");
        }
        
    }];
    
}



- (void)saveProfile {
    NSLog(@"save profile called: %@", self.alias);
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    ProfileObject* profileEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Profile"
                                                                inManagedObjectContext:self.managedObjectContext];



    //NSManagedObjectContext *context = [appDelegate managedObjectContext];
    //NSManagedObject *profile;
    //profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
    [profileEntry setValue:self.alias forKey:@"alias"];
    [profileEntry setValue:self.chapterID forKey:@"chapterID"];
    NSError *error;
    [self.managedObjectContext save:&error];
    NSLog(@"profileEntry:%@",profileEntry);
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)saveAvatar:(UIImage *)avatar {
    //NSLog(@"save profile called: %@", alias);
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    ProfileObject* profileEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Profile"
                                                                inManagedObjectContext:self.managedObjectContext];



    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *profile;
    profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];

    NSData *imageData = UIImagePNGRepresentation(avatar);
    [profile setValue:imageData forKey:@"avatar"];
    NSError *error;

    @try{

        if (_managedObjectContext != nil) {

            if (![_managedObjectContext save:&error]) {

                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

                NSString * infoString = [NSString stringWithFormat:@"Please check your connection and try again."];

                UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Database Connection Error" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

                NSLog(@"alert: %@",infoAlert);
            }
        }
    }@catch (NSException *exception) {

        NSLog(@"inside exception");
    }
}


- (IBAction)back:(id)sender {
    LogInViewController *lvc = [[LogInViewController alloc] init];
    lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"lvc"];
    [self presentViewController:lvc animated:YES completion:nil];
    NSLog(@"show lvc");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.chapterCode isFirstResponder] && [touch view] != self.chapterCode) {
        [self.chapterCode resignFirstResponder];
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
