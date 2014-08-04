//
//  CheckLoginViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/13/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "CheckLoginViewController.h"
#import "LogInViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "NavigationController.h"

@interface CheckLoginViewController ()
@property (nonatomic,strong)NSArray* fetchedProfilesArray;

@end

@implementation CheckLoginViewController


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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    if (![PFUser currentUser]) {
        NSLog(@"not logged in");
        //[self performSelector:@selector(callLogin) withObject:nil afterDelay:4.0f];
        
        
        LogInViewController *lvc = [[LogInViewController alloc] init];
        lvc = [storyboard instantiateViewControllerWithIdentifier:@"lvc"];
        NSLog(@"show lvc");
        
        [self presentViewController:lvc animated:YES completion:nil];
        //[self.navigationController pushViewController:lvc animated:YES];

        [activityIndicator stopAnimating];
        NSLog(@"activity indicator stopped");
        
        
    } else {
//
        
        self.fetchedProfilesArray = [[NSArray alloc] init];
        
        AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.fetchedProfilesArray = [appDelegate getProfiles];
        
        NSManagedObject *profile = nil;
        NSUInteger count = [self.fetchedProfilesArray count];
        NSLog(@"fetched profiles count CHECK LOGIN VC: %lu",(unsigned long)count);
        
            
            profile = self.fetchedProfilesArray[count-1];
            self.alias = [profile valueForKey:@"alias"];
            self.chapterID = [profile valueForKey:@"chapterID"];
        
        NSLog(@"CHECKLOGIN:%@------%@",self.alias, self.chapterID);

        HomeViewController *hvc = [[HomeViewController alloc] init];
        hvc = [storyboard instantiateViewControllerWithIdentifier:@"hvc"];

        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:hvc];
        self.frostedViewController.contentViewController = navigationController;

        
        //HomeViewController *hvc = [[HomeViewController alloc] init];
        //hvc = [storyboard instantiateViewControllerWithIdentifier:@"hvc"];
        //MenuViewController *mvc = [[MenuViewController alloc] init];
        //mvc.chapterID = self.chapterID;
        //mvc.alias = self.alias;
        hvc.chapterID = self.chapterID;
        hvc.alias = self.alias;
////        hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"hvc"];
//        //[self presentViewController:hvc animated:YES completion:nil];
//        NSLog(@"show hvc");
//        //[self presentViewController:hvc animated:YES completion:nil];
       //[self.navigationController pushViewController:hvc animated:YES];
//
//        [activityIndicator stopAnimating];
//        NSLog(@"activity indicator stopped");
//        
//        
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
