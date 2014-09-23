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
#import "LogUserInViewController.h"

@interface SignUpViewController ()

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
            
            LogUserInViewController *logUserInViewController = [[LogUserInViewController alloc] initWithNibName:@"LogUserInViewController" bundle:nil];
            AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            ad.window.rootViewController = [[UIViewController alloc] init];
            ad.window.rootViewController = logUserInViewController;

            
        } else {
            NSLog(@"could not register");
        }
        
    }];
    
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
