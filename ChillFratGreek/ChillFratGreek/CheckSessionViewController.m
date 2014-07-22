//
//  CheckSessionViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "CheckSessionViewController.h"
#import "LogInViewController.h"
#import "HomeViewController.h"

@interface CheckSessionViewController ()

@end

@implementation CheckSessionViewController

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
    NSLog(@"csvc shown");

    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    NSLog(@"activity indicator started");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![PFUser currentUser]) {
        NSLog(@"not logged in");
        //[self performSelector:@selector(callLogin) withObject:nil afterDelay:4.0f];

        LogInViewController *lvc = [[LogInViewController alloc] init];
        lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"lvc"];
         NSLog(@"show lvc");
        [self presentViewController:lvc animated:YES completion:nil];
        [activityIndicator stopAnimating];
        NSLog(@"activity indicator stopped");


    } else {
        NSLog(@"logged in");
        HomeViewController *hvc = [[HomeViewController alloc] init];
        hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"hvc"];
        NSLog(@"show hvc");
        [self presentViewController:hvc animated:YES completion:nil];
        [activityIndicator stopAnimating];
        NSLog(@"activity indicator stopped");


    }
}

//- (void) callLogin {
//    LogInViewController *lvc = [[LogInViewController alloc] init];
//    lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"lvc"];
//    NSLog(@"show lvc");
//    [self presentViewController:lvc animated:YES completion:nil];
//    //[_spinner stopAnimating];
//
//}

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
