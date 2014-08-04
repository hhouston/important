//
//  RusheesTableViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "RusheesTableViewController.h"
#import "NavigationController.h"
#import "RusheeDetailViewController.h"
#import "RusheeTableViewCell.h"
#import "RusheeObject.h"

@interface RusheesTableViewController ()

@end

@implementation RusheesTableViewController {
    NavigationController *navc;
    UIImage *menuImage;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"rushees";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // The title for this table in the Navigation Controller.
        self.title = @"chapterName";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        //self.paginationEnabled = YES;
        
        // The number of objects to show per page
        //self.objectsPerPage = 5;
    }
    return self;
}
//- (PFQuery *)queryForTable
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"rushees"];
//    //[query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject *currentUserObject, NSError *error) {
//        // Do something with the returned PFObject in the gameScore variable.
//        NSLog(@"%@", query);
//    //}];
//    //PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//    
//    
//    return query;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title = @"Rush List";
    //self.view.backgroundColor = [UIColor orangeColor];
    
    //declare here to fix bug
    //ARC is autoreleasing your secondView controller before your selector is being called?
    navc = [[NavigationController alloc] init];
    menuImage = [[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:(NavigationController *)self.navigationController action:@selector(showMenu)];

    

//    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//    [query whereKey:@"chapterID" equalTo:self.chapterID];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *rushees, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)rushees.count);
//            // Do something with the found objects
//            self.rusheeObjs = rushees;
//
//            NSInteger count = 0;
//            for (PFObject *rushee in rushees) {
//                NSLog(@"%@", rushee.objectId);
//                [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:count] object:rushee];
//                count++;
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];

    
    // The InBackground methods are asynchronous, so any code after this will run
    // immediately.  Any code that depends on the query result should be moved
    // inside the completion block above.
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    NSLog(@"chapterID: %@", self.chapterID);
    [query whereKey:@"chapterID" equalTo:self.chapterID];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"downVotes"];
    
    return query;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//                        object:(PFObject *)object
//{
//    static NSString *cellIdentifier = @"Cell";
//    
//   // NSLog(@"name of rushees: %@",rusheeObjs objectAtIndex:<#(NSUInteger)#> [@"name"]);
//    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                      reuseIdentifier:cellIdentifier];
//    }
//    
//    // Configure the cell to show todo item with a priority at the bottom
//    cell.textLabel.text = object[@"name"];
////    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",
////                                 object[@"priority"]];
//    
//    return cell;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    RusheeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        cell = [[RusheeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RusheeTableViewCell" owner:nil options:nil] objectAtIndex:0];
        //cell.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.3];
        //cell.layer.cornerRadius = 5.0;
        //cell.backgroundColor = [UIColor clearColor];
        [cell setClipsToBounds:YES];
        //cell.backgroundColor = [UIColor clearColor];
        //cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    }
    
    cell.rusheeFirstName.text = object[@"firstName"];
    cell.rusheeLastName.text = object[@"lastName"];

    PFFile *thumbnail = object[@"avatar"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *avatar = [UIImage imageWithData:data];
        cell.imageView.image = avatar;

    }];
    
    cell.imageView.image = [UIImage imageNamed:@"user"];
    //NSString *distance = [NSString stringWithFormat:@"%0.2fmi",tempMarker.distance];
    //cell.distance.text = distance;
    //cell.distance.textColor = [UIColor blackColor];
    
    //NSLog(@"name:%@",tempMarker.userData[@"name"]);
    //cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7];
    
    return cell;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.objects count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    RusheeDetailViewController *rusheeDetailViewController = [[RusheeDetailViewController alloc]
     initWithNibName:@"RusheeDetailViewController"
     bundle:nil];
    PFObject *obj =  [self.objects objectAtIndex:(NSUInteger)indexPath.row];
    [rusheeDetailViewController setReceiveObject:obj];
     // ...
     // Pass the selected object to the new view controller.
     //[self.navigationController pushViewController:rusheeDetailViewController animated:YES];
    
    
//    if (0 == indexPath.row)
//    {
//        rusheeDetailViewController.title = @"one";
//    } else {
//        rusheeDetailViewController.title = @"two";
//    }
    [self.navigationController
     pushViewController:rusheeDetailViewController
     animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
@end
