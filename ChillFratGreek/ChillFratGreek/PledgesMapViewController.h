//
//  PledgesMapViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/10/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>

@interface PledgesMapViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString* chapterID;

@end
