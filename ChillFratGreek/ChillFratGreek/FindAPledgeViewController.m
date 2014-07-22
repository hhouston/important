//
//  FindAPledgeViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/21/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

static CGFloat kOverlayHeight = 100.0f;

#import "FindAPledgeViewController.h"
#import "NavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface FindAPledgeViewController () <CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    GMSMapView *mapView_;
    GMSGeocoder *geocoder_;
    NSMutableArray *markers_;

    NavigationController *navc;

}


@end

@implementation FindAPledgeViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"pledges";
        
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

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect frame = self.tableView.frame;
    frame.origin.y += 100.0;
    frame.size.height -= 100.0;
    self.tableView.frame = frame;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navc = [[NavigationController alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:navc.navigationController
                                                                            action:@selector(showMenu)];
    

    
    [self setUpMapView];
    //[self setUpTableView];
    
    // Do any additional setup after loading the view.
}

- (void)setUpMapView {
    markers_ = [[NSMutableArray alloc] init];
    geocoder_ = [[GMSGeocoder alloc] init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    
    //mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 44, 320, 284) camera:camera];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    
    mapView_.padding = UIEdgeInsetsMake(0, 0, kOverlayHeight, 0);
    mapView_.delegate = self;
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    [self.view addSubview:mapView_];
    //self.view = mapView_;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });

}

//-(void)setUpTableView {
//    //CGRect overlayFrame = CGRectMake(0, -kOverlayHeight, 0, kOverlayHeight);
//    //self.tableView = [[UITableView alloc] initWithFrame:overlayFrame];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//
//    [self.tableView reloadData];
//    
//    self.tableView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7];
//    //overlay_.opaque = NO;
//    
//    //[self.view addSubview:self.tableView];
//    //[overlay_ setHidden:YES];
//
//    
//}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *cellIdentifier = @"Cell";
    
    // NSLog(@"name of rushees: %@",rusheeObjs objectAtIndex:<#(NSUInteger)#> [@"name"]);
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = object[@"name"];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",
    //                                 object[@"priority"]];
    
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
    
//    RusheeDetailViewController *rusheeDetailViewController = [[RusheeDetailViewController alloc]
//                                                              initWithNibName:@"RusheeDetailViewController"
//                                                              bundle:nil];
//    rusheeDetailViewController.rusheeObj =  [self.objects objectAtIndex:(NSUInteger)indexPath.row];
//    // ...
//    // Pass the selected object to the new view controller.
//    //[self.navigationController pushViewController:rusheeDetailViewController animated:YES];
//    
//    
//    //    if (0 == indexPath.row)
//    //    {
//    //        rusheeDetailViewController.title = @"one";
//    //    } else {
//    //        rusheeDetailViewController.title = @"two";
//    //    }
//    [self.navigationController
//     pushViewController:rusheeDetailViewController
//     animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
