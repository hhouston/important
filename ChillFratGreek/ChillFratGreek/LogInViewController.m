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
#import "LogUserInViewController.h"

@interface LogInViewController ()
@property (nonatomic,strong)NSArray* fetchedProfilesArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation LogInViewController {
    HomeViewController *hvc;
    SignUpViewController *svc;
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
            AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            LogUserInViewController *logUserInViewController = [[LogUserInViewController alloc] initWithNibName:@"LogUserInViewController" bundle:nil];
            ad.window.rootViewController = logUserInViewController;

        }
    }];
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

@end
