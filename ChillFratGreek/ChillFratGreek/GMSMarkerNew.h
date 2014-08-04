//
//  GMSMarkerNew.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/22/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GMSMarkerNew : GMSMarker

@property (assign, nonatomic) float distance;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *address2;
@property (assign, nonatomic) NSUInteger markerIndex;

@end
