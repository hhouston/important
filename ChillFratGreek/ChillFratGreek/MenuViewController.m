//
//  MenuViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/7/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeViewController.h"
#import "RusheesTableViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "NavigationController.h"
#import "RusheesTableViewController.h"
#import "PledgesMapViewController.h"
#import "WhiteboardViewController.h"
#import "ProfileObject.h"
#import "AppDelegate.h"
#import "utilities.h"

@interface MenuViewController ()
@property (nonatomic,strong)NSArray* fetchedProfilesArray;

@end


@implementation MenuViewController {
    PFImageView *imageView;
    NSString *aliasString;
    RusheesTableViewController *rtvc;
    PledgesMapViewController *pmvc;
    HomeViewController *hvc;
    WhiteboardViewController *wvc;
    ProfileObject *profileObject;
    UIButton *profileButton;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    rtvc = [[RusheesTableViewController alloc] init];
    hvc = [[HomeViewController alloc] init];
    
    //self.alias = hvc.alias;
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    self.fetchedProfilesArray = [appDelegate getProfiles];

    NSManagedObject *profile = nil;
    NSUInteger count = [self.fetchedProfilesArray count];
    NSLog(@"PROFILE COUNTER SHOULD BE ONLY 1: #%lu",(unsigned long)count);
    profile = self.fetchedProfilesArray[count-1];
    self.alias = [profile valueForKey:@"alias"];
    self.chapterID = [profile valueForKey:@"chapterID"];
    
    NSLog(@"MVC ALIAS:%@",self.alias);
    
    
    //NSLog(@"%@",string);
    //UIImage *avatarImage = profileObject.avatar;

    //alias = [[NSString alloc] init];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    //self.tableView.separatorColor = [UIColor colorWithRed:30/255.0f green:41/255.0f blue:57/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        //PFUser *user = [PFUser currentUser];
        //[imageView setFile:[user objectForKey:@"avatar"]];
        //[imageView loadInBackground];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        profileButton.layer.masksToBounds = YES;
        profileButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        profileButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        profileButton.layer.shouldRasterize = YES;
        profileButton.clipsToBounds = YES;
        
        [profileButton addTarget:self action:@selector(profileButtonPressed:) forControlEvents:UIControlEventTouchDown];
        // Do something with the returned PFObject in the gameScore variable.
        //imageView.file = profileObject.avatar.file;
        //[imageView loadInBackground];

        //self.alias = profileObject.userAlias;
        //aliasString = [[NSString alloc] init];
        //aliasString = profileObject.userAlias;
        //aliasString = hvc.alias;

        NSLog(@"ALIAS: %@",self.alias);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = self.alias;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:profileButton];
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
}


-(void)profileButtonPressed:(UIButton *)sender{
    
    ShouldStartPhotoLibrary(self, YES);

}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0 || sectionIndex == 1)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0 || sectionIndex == 1)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:homeViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else if (indexPath.section == 0 && indexPath.row == 1){
        
        rtvc.chapterID = self.chapterID;
        //[rtvc setChapterID2:self.chapterID];
        
        //RusheesTableViewController *secondViewController = [[RusheesTableViewController alloc] init];
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:rtvc];
        self.frostedViewController.contentViewController = navigationController;
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        pmvc = [[PledgesMapViewController alloc] init];
        pmvc.chapterID = self.chapterID;
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:pmvc];

        self.frostedViewController.contentViewController = navigationController;
        
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        wvc = [[WhiteboardViewController alloc] init];
        wvc.chapterID = self.chapterID;
        NavigationController *navigationController = [[NavigationController alloc ] initWithRootViewController:wvc];
        
        self.frostedViewController.contentViewController = navigationController;
    } else if (indexPath.section == 0 && indexPath.row == 4) {
        //fapvc = [[FindAPledgeViewController alloc] init];
        //fapvc.chapterID = self.chapterID;
        //NavigationController *navigationController = [[NavigationController alloc ] initWithRootViewController:fapvc];
        
        //self.frostedViewController.contentViewController = navigationController;
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
        NSArray *titles = @[@"Home", @"Rush List", @"find a pledge",@"whiteboard", @"Party", @"settings", @"rush tits"];
        cell.textLabel.text = titles[indexPath.row];

    
    return cell;
}

@end
