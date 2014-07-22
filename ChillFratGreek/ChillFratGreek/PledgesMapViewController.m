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

static CGFloat kOverlayHeight = 200.0f;

@interface PledgesMapViewController () {
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    //UITableView *overlay_;
    UIImageView *radarView;
    NavigationController *navc;
    UIBarButtonItem *flyInButton_;
    GMSMarker *fadedMarker_;
    GMSMarker *tempMarker;
    GMSGeocoder *geocoder_;
    NSInteger *number;
    NSMutableArray *markers_;
    BOOL ranOnce;
    BOOL firstMarkerClick;
    NSString *phoneNumber;
    UILabel *nameLabel;
    UIButton *callButton;
    NSUInteger numberOfObjects;
}

@property (nonatomic, retain) UITableView *overlay_;

@end

@implementation PledgesMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"find a pledge";
    ranOnce = false;
    firstMarkerClick = false;
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

- (void)didTapFlyIn:(GMSMarker *)marker {
    UIEdgeInsets padding = mapView_.padding;

    phoneNumber = marker.userData[@"phone"];
    
    callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 7, 30, 30)];
    [callButton setBackgroundImage:[UIImage imageNamed:@"phone_icon20x.png"] forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchDown];
    [mapView_ addSubview:callButton];
    
    


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
       
        numberOfObjects = objects.count;
        if (ranOnce == false ) {
        
            if (!error) {
            
            ranOnce = true;
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu pledges.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSLog(@"LOCATION:%@",object[@"location"]);
                PFGeoPoint *tempPoint = object[@"location"];
                [self setMarker:tempPoint forObject:object];
            }
            } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
       
            }
            //[self.overlay_ performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self stopRadar];
            
        } else {
            
            if (!error) {
                [mapView_ clear];
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu pledges.", (unsigned long)objects.count);
                // Do something with the found objects
                    GMSCoordinateBounds *bounds;
                NSUInteger count = 0;
                //markers_ = [[NSMutableArray alloc] init];

                for (PFObject *object in objects) {
                    
                    NSLog(@"%@", object.objectId);
                    NSLog(@"LOCATION:%@",object[@"location"]);
                    PFGeoPoint *tempPoint = object[@"location"];
                    [self updateMarker:tempPoint forObject:object atIndex:count];
                    count++;
                }
                
                
//                for (GMSMarker *marker in markers_) {
//                    NSLog(@"Marker count:%lu",(unsigned long)markers_.count);
//                    if (bounds == nil) {
//                        bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.position
//                                                                      coordinate:marker.position];
//                    }
//                    bounds = [bounds includingCoordinate:marker.position];
//                }
//                GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
//                                                         withPadding:50.0f];
//                [mapView_ moveCamera:update];
                
                
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            }
            [self stopRadar];

        }
        

    }];

//    GMSCoordinateBounds *bounds;
//    for (GMSMarker *marker in markers_) {
//        NSLog(@"Marker count:%lu",(unsigned long)markers_.count);
//        if (bounds == nil) {
//            bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.position
//                                                          coordinate:marker.position];
//        }
//        bounds = [bounds includingCoordinate:marker.position];
//    }
//    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
//                                             withPadding:50.0f];
//    [mapView_ moveCamera:update];
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
            
            
            tempMarker = [[GMSMarker alloc] init];
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
            
            tempMarker.map = mapView_;

            [markers_ addObject:tempMarker];
            NSLog(@"setmarker1:%@\nmarker count:%lu",tempMarker,(unsigned long)markers_.count);
            
            //GMSMarker *marker = [GMSMarker markerWithPosition:address.coordinate];
            
            if (numberOfObjects == markers_.count) {
                [self.overlay_ reloadData];
            }
            //marker.map = mapView_;
        } else {
            NSLog(@"Could not reverse geocode point (%f,%f): %@",
                  currentCoordinates.latitude, currentCoordinates.longitude, error);
            
            tempMarker = [[GMSMarker alloc] init];
            tempMarker.position = currentCoordinates;
            //tempMarker.position = address.coordinate;
            tempMarker.userData = pledge;
            NSLog(@"phone:%@",tempMarker.userData[@"phone"]);
            tempMarker.title = pledge[@"name"];
            NSString *distance = @"";
            tempMarker.snippet = [NSString stringWithFormat:@"distance=%@",distance];
            //tempMarker.snippet = [[address lines] firstObject];
            tempMarker.appearAnimation = kGMSMarkerAnimationPop;
            tempMarker.map = mapView_;
            
            [markers_ addObject:tempMarker];
            NSLog(@"setmarker2:%@\nmarker count:%lu",tempMarker,(unsigned long)markers_.count);
            [self.overlay_ reloadData];

        }
    };
    [geocoder_ reverseGeocodeCoordinate:currentCoordinates completionHandler:handler];



}

- (void) updateMarker:(PFGeoPoint *)location forObject:(PFObject *)pledge atIndex:(NSUInteger)count {
    
    
    NSLog(@"UPDATE MARKER:%@",pledge[@"name"]);
    double latitude = location.latitude;
    double longitude = location.longitude;
    //GMSMarker *tempMarker =[[GMSMarker alloc] init];
    //NSString stringWithFormat:@"%dpledge-i",number];

    
    
    CLLocationCoordinate2D currentCoordinates = CLLocationCoordinate2DMake(latitude,longitude);
    
    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSAddress *address = response.firstResult;

        
        if (address) {
            NSLog(@"Geocoder result: %@", address);
            
            tempMarker = [[GMSMarker alloc] init];
            //tempMarker.position = currentCoordinates;
            tempMarker.position = address.coordinate;
            tempMarker.userData = pledge;
            NSLog(@"phone:%@",tempMarker.userData[@"phone"]);
            //tempMarker.title = pledge[@"name"];
            //tempMarker.snippet = @"%@3660 chevy chase (5mi) - 34s";
            //tempMarker.snippet = [[address lines] firstObject];
            tempMarker.appearAnimation = kGMSMarkerAnimationPop;
            
            tempMarker.title = [[address lines] firstObject];
            if ([[address lines] count] > 1) {
                tempMarker.snippet = [[address lines] objectAtIndex:1];
            }
            
            tempMarker.map = mapView_;
            [markers_ insertObject:tempMarker atIndex:count];
            //[markers_ addObject:tempMarker];
            NSLog(@"updatemarker1:%@\nmarker count:%lu",tempMarker,(unsigned long)markers_.count);

        } else {
            NSLog(@"Could not reverse geocode point (%f,%f): %@",
                  currentCoordinates.latitude, currentCoordinates.longitude, error);
            
            tempMarker = [[GMSMarker alloc] init];
            tempMarker.position = currentCoordinates;
            //tempMarker.position = address.coordinate;
            tempMarker.userData = pledge;
            NSLog(@"phone:%@",tempMarker.userData[@"phone"]);
            tempMarker.title = pledge[@"name"];
            tempMarker.snippet = @"%@3660 chevy chase (5mi) - 34s";
            //tempMarker.snippet = [[address lines] firstObject];
            tempMarker.appearAnimation = kGMSMarkerAnimationPop;
            tempMarker.map = mapView_;
            
            [markers_ addObject:tempMarker];
            NSLog(@"updatemarker2:%@\nmarker count:%lu",tempMarker,(unsigned long)markers_.count);
            
        }
    };
    [geocoder_ reverseGeocodeCoordinate:currentCoordinates completionHandler:handler];

    
    
    tempMarker.position = CLLocationCoordinate2DMake(latitude,longitude);
    tempMarker.userData = pledge;
    NSLog(@"phone:%@",tempMarker.userData[@"phone"]);
    tempMarker.title = pledge[@"name"];
    tempMarker.snippet = @"3660 chevy chase (5mi) - 34s";
    tempMarker.map = mapView_;
    [markers_ addObject:tempMarker];
    NSLog(@"tempMarker:%@\nmarker count:%lu",tempMarker,(unsigned long)markers_.count);
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
- (void)fadeMarker:(GMSMarker *)marker {
    fadedMarker_.opacity = 1.0f;  // reset previous faded marker
    
    // Fade this new marker.
    fadedMarker_ = marker;
    fadedMarker_.opacity = 0.5f;
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    	CGPoint point = [mapView.projection pointForCoordinate:marker.position];
    	point.y = point.y - 100;
    	GMSCameraUpdate *camera =
        [GMSCameraUpdate setTarget:[mapView.projection coordinateForPoint:point]];
    	[mapView animateWithCameraUpdate:camera];
    	NSLog(@"tapped marker:%@",marker.userData[@"name"]);
    	mapView.selectedMarker = marker;
        [self didTapFlyIn:marker];
    //[self fadeMarker:marker];
    
	return YES;
}


- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
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
    
    tempMarker = [[GMSMarker alloc] init];
    
    tempMarker = [markers_ objectAtIndex:indexPath.row];
    cell.textLabel.text = tempMarker.userData[@"name"];
    NSLog(@"name:%@",tempMarker.userData[@"name"]);
    cell.backgroundColor = [UIColor clearColor];

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

