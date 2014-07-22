//
//  PledgesMapViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/10/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

#import "PledgesMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import "GMSMarkerNew.h"

static CGFloat kOverlayHeight = 200.0f;

@interface PledgesMapViewController () {
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    //UITableView *overlay_;
    UIImageView *radarView;
    NavigationController *navc;
    UIBarButtonItem *flyInButton_;
    GMSMarkerNew *fadedMarker_;
    GMSMarkerNew *tempMarker;
    GMSGeocoder *geocoder_;
    NSInteger *number;
    NSMutableArray *markers_;
    NSArray *sortedMarkerArray;
    
    NSString *phoneNumber;
    UILabel *nameLabel;
    UILabel *distanceLabel;
    
    UIButton *callButton;
    UIButton *textButton;
    UIButton *pingButton;
    
    NSUInteger numberOfObjects;
    NSUInteger markerIndex;
}

@property (nonatomic, retain) UITableView *overlay_;

@end

@implementation PledgesMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"find a pledge";
    navc = [[NavigationController alloc] init];
    markers_ = [[NSMutableArray alloc] init];
    geocoder_ = [[GMSGeocoder alloc] init];
    
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 50, 40)];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont fontWithName:@"Trebuchet MS" size:14.0f]];

    
//    callButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 30, 55, 55)];
//    [callButton setBackgroundImage:[UIImage imageNamed:@"phone_icon20x.png"] forState:UIControlStateNormal];
//    [callButton addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchDown];
    //[overlay_ addSubview:callButton];
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:navc.navigationController
                                                                            action:@selector(showMenu)];
    
    //[self setRefreshButton];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"Map",@"Task"]];
    //segmentControl.frame = CGRectMake(10, 50, 300, 30);
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:0];

    [self.navigationController.navigationBar.topItem setTitleView:segmentControl];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];

    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width) camera:camera];

    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.padding = UIEdgeInsetsMake(0, 0, kOverlayHeight, 0);
    mapView_.delegate = self;
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    //[self.view addSubview:mapView_];
    self.view = mapView_;

    
    
    CGRect overlayFrame = CGRectMake(0, -kOverlayHeight,0, kOverlayHeight);
    self.overlay_ = [[UITableView alloc] initWithFrame:overlayFrame];
    self.overlay_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.overlay_.dataSource = self;
    self.overlay_.delegate = self;

    self.overlay_.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7];

    [self.view addSubview:self.overlay_];
    
    //[overlay_ setHidden:YES];
    //[self didTapFlyIn];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
    [self startRadar];

}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    id hitView = [super hitTest:point withEvent:event];
//    if (point.y<0) {
//        return nil;
//    }
//    return hitView;
//}
//
//-(void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    self.overlay_.contentInset = UIEdgeInsetsMake(self.view.frame.size.height-40, 0, 0, 0);
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    if (scrollView.contentOffset.y < self.view.frame.size.height*-1 ) {
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, self.view.frame.size.height*-1)];
//    }
//}

- (void) setRefreshButton {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(startRadar)];
}


- (void)startRadar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopRadar)];
    
    radarView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 75, 90,90)];


    radarView.image = [UIImage imageNamed:@"blue radar one circle 90x.png"];
    //radarView.center =
    [mapView_ addSubview:radarView];
    [self rotateImage:radarView duration:2.0
                curve:UIViewAnimationCurveEaseIn degrees:180];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"pledges"];
    [query whereKey:@"chapterID" equalTo:self.chapterID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        markers_ = [[NSMutableArray alloc] init];
        numberOfObjects = objects.count;
        markerIndex = 0;
        [mapView_ clear];
            if (!error) {

            NSLog(@"Successfully retrieved %lu pledges.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                
                //NSLog(@"%@", object.objectId);
                //NSLog(@"LOCATION:%@",object[@"location"]);
                PFGeoPoint *tempPoint = object[@"location"];
                [self setMarker:tempPoint forObject:object];
            }
            } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
       
            }
            //[self.overlay_ performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self stopRadar];
        }];

}

- (void)reloadData {
    [self.overlay_ reloadData];

}

- (void)stopRadar {
    [self setRefreshButton];
    [radarView removeFromSuperview];
}

- (void) setMarker:(PFGeoPoint *)location forObject:(PFObject *)pledge{
    double latitude = location.latitude;
    double longitude = location.longitude;
    //GMSMarker *tempMarker =[[GMSMarker alloc] init];
    //NSString stringWithFormat:@"%dpledge-i",number];
    NSLog(@"SET MARKER:%@",pledge[@"name"]);

    CLLocationCoordinate2D currentCoordinates = CLLocationCoordinate2DMake(latitude,longitude);

    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSAddress *address = response.firstResult;
        
        if (address) {
            NSLog(@"Geocoder result: %@", address);
            

            tempMarker = [[GMSMarkerNew alloc] init];
            //tempMarker.position = currentCoordinates;
            tempMarker.position = address.coordinate;
            tempMarker.userData = pledge;
            //NSLog(@"phone:%@",tempMarker.userData[@"phone"]);
            //tempMarker.title = pledge[@"name"];
            //tempMarker.snippet = @"%@3660 chevy chase (5mi) - 34s";
            //tempMarker.snippet = [[address lines] firstObject];
            tempMarker.appearAnimation = kGMSMarkerAnimationPop;
            
            tempMarker.title = [[address lines] firstObject];
            if ([[address lines] count] > 1) {
                tempMarker.snippet = [[address lines] objectAtIndex:1];
            }
            
            
            [markers_ addObject:tempMarker];

            tempMarker.map = mapView_;

            NSLog(@"setmarker1:%@\nmarker count:%lu",tempMarker,(unsigned long)markers_.count);
            
            //GMSMarker *marker = [GMSMarker markerWithPosition:address.coordinate];
            
            if (numberOfObjects == markerIndex+1) {
                //[self.overlay_ reloadData];
                [self orderByDistance];
            }
            //marker.map = mapView_;
        } else {
            NSLog(@"Could not reverse geocode point (%f,%f): %@",
                  currentCoordinates.latitude, currentCoordinates.longitude, error);
            
            
            
            tempMarker = [[GMSMarkerNew alloc] init];
            //tempMarker.position = currentCoordinates;
            tempMarker.position = address.coordinate;
            tempMarker.userData = pledge;
            //NSLog(@"phone:%@",tempMarker.userData[@"phone"]);
            //tempMarker.title = pledge[@"name"];
            //tempMarker.snippet = @"%@3660 chevy chase (5mi) - 34s";
            //tempMarker.snippet = [[address lines] firstObject];
            tempMarker.appearAnimation = kGMSMarkerAnimationPop;
            //tempMarker.title = pledge[@"name"];
            NSString *distance = @"";
            //tempMarker.snippet = [NSString stringWithFormat:@"distance=%@",distance];

            
//            if (markerIndex + 1 == numberOfObjects) {
//                [markers_ replaceObjectAtIndex:markerIndex withObject:tempMarker];
//            } else {
                [markers_ addObject:tempMarker];
                
            //}
            tempMarker.map = mapView_;
            
            NSLog(@"setmarker1:%@\nmarker count:%lu",tempMarker,(unsigned long)markers_.count);
            
            //GMSMarker *marker = [GMSMarker markerWithPosition:address.coordinate];
            
            if (numberOfObjects == markerIndex+1) {
                //[self.overlay_ reloadData];
                [self orderByDistance];
            }

        }
        
        markerIndex++;
    };
    [geocoder_ reverseGeocodeCoordinate:currentCoordinates completionHandler:handler];



}

-(void)orderByDistance {
    
    for (GMSMarkerNew *marker in markers_) {
        
        CLLocation *markerLocation = [[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
        float distInMeter = [markerLocation distanceFromLocation:mapView_.myLocation]; // which returns in meters
        float distInMile = 0.000621371192 * distInMeter;
        NSLog(@"Actual Distance in Mile : %f",distInMile);
        
        marker.distance = distInMile;
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:descriptor, nil];
        
        sortedMarkerArray = [[NSArray alloc] init];
        sortedMarkerArray = [markers_ sortedArrayUsingDescriptors:sortDescriptors];
    }
    [self reloadData];
}
- (void)dealloc {
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}
- (void)fadeMarker:(GMSMarkerNew *)marker {
    fadedMarker_.opacity = 1.0f;  // reset previous faded marker
    
    // Fade this new marker.
    fadedMarker_ = marker;
    fadedMarker_.opacity = 0.5f;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarkerNew *)marker
{
    	CGPoint point = [mapView.projection pointForCoordinate:marker.position];
    	point.y = point.y - 100;
    	GMSCameraUpdate *camera =
        [GMSCameraUpdate setTarget:[mapView.projection coordinateForPoint:point]];
    	[mapView animateWithCameraUpdate:camera];
    	NSLog(@"tapped marker:%@",marker.userData[@"name"]);
    	mapView.selectedMarker = marker;
        [self didTapFlyIn:marker];
    
	return YES;
}
- (void)didTapFlyIn:(GMSMarkerNew *)marker {
    UIEdgeInsets padding = mapView_.padding;
    
    phoneNumber = marker.userData[@"phone"];
    
    callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, 80, 60, 60)];
    [callButton setBackgroundImage:[UIImage imageNamed:@"phone_icon20x.png"] forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchDown];
    callButton.alpha = 0.0;
    [self.view addSubview:callButton];

    [UIView animateWithDuration:2.0 animations:^{
        callButton.alpha = 1.0;
        
    }];
    
    textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    textButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, 100, 45, 45)];
    [textButton setBackgroundImage:[UIImage imageNamed:@"phone_icon20x.png"] forState:UIControlStateNormal];
    textButton.backgroundColor = [UIColor whiteColor];
    textButton.layer.cornerRadius = 3;
    textButton.clipsToBounds = YES;
    [textButton addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchDown];
    //textButton.alpha = 0.0;
    [self.view addSubview:textButton];
    
    //callbutton
    
    [UIView animateWithDuration:1.0 animations:^{
        
        CGSize size = self.view.bounds.size;
        
        //if (padding.bottom == 0.0f) {
        //nameLabel.text = marker.userData[@"name"];
        //[self.overlay_ addSubview:nameLabel];
        
        //phoneNumber = marker.userData[@"phone"];
        //[self.overlay_ addSubview:callButton];
        
        self.overlay_.frame = CGRectMake(0, size.height - kOverlayHeight, size.width, kOverlayHeight);
        mapView_.padding = UIEdgeInsetsMake(0, 0, kOverlayHeight, 0);
        //} else {
        //overlay_.frame = CGRectMake(0, mapView_.bounds.size.height, size.width, 0);
        //mapView_.padding = UIEdgeInsetsZero;
        //}
        
    }];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [UIView animateWithDuration:2.0 animations:^{
        callButton.alpha = 0.0;
        
    }];
    //[callButton removeFromSuperview];
    
    CGSize size = self.view.bounds.size;
    [UIView animateWithDuration:1.0 animations:^{

    self.overlay_.frame = CGRectMake(0, mapView_.bounds.size.height, size.width, 0);
    mapView_.padding = UIEdgeInsetsZero;
        
    }];
//    for (int x = 0; x < mapView_.markers.count; x++)
//    {
//        GMSMarker * tempMarker = mapView_.markers[x];
//        tempMarker.tappable = YES;
//    }
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = duration; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [image.layer addAnimation:rotation forKey:@"Spin"];
}

-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            //action for the first button (Current)
            break;}
        case 1:{
            //action for the first button (Current)
            break;}
    }
}

-(void)callPhone {
    NSString *fullNumber = [NSString stringWithFormat:@"tel:%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullNumber]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (markers_.count == 0) {
        return cell;
        cell.backgroundColor = [UIColor clearColor];

    }
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 40)];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont fontWithName:@"Trebuchet MS" size:14.0f]];
    
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 50, 40)];
    [distanceLabel setTextColor:[UIColor blackColor]];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    [distanceLabel setFont:[UIFont fontWithName:@"Trebuchet MS" size:14.0f]];
    
    tempMarker = [[GMSMarkerNew alloc] init];
    tempMarker = [sortedMarkerArray objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = tempMarker.userData[@"name"];
    nameLabel.text = tempMarker.userData[@"name"];
    NSString *distance = [NSString stringWithFormat:@"%f",tempMarker.distance];
    distanceLabel.text = distance;
    
    NSLog(@"name:%@",tempMarker.userData[@"name"]);
    cell.backgroundColor = [UIColor clearColor];

    
    [cell addSubview:nameLabel];
    [cell addSubview:distanceLabel];
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
    return markers_.count;
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    [self mapView:mapView_ didTapMarker:sortedMarkerArray[indexPath.row]];
    
    
    
    
    //RusheeDetailViewController *rusheeDetailViewController = [[RusheeDetailViewController alloc]
//                                                              initWithNibName:@"RusheeDetailViewController"
//                                                              bundle:nil];
//    rusheeDetailViewController.rusheeObj =  [self.objects objectAtIndex:(NSUInteger)indexPath.row];
    // ...
    // Pass the selected object to the new view controller.
    //[self.navigationController pushViewController:rusheeDetailViewController animated:YES];
    
    
    //    if (0 == indexPath.row)
    //    {
    //        rusheeDetailViewController.title = @"one";
    //    } else {
    //        rusheeDetailViewController.title = @"two";
    //    }
//    [self.navigationController
//     pushViewController:rusheeDetailViewController
//     animated:YES];
}


@end

