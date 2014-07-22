//
//  FindAPledgeViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/21/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FindAPledgeViewController : PFQueryTableViewController

@property (strong, nonatomic) NSString* chapterID;
@property (nonatomic, retain) UITableView *overlay_;

@end
