//
//  MenuViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/7/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h> 

@interface MenuViewController : UITableViewController
@property (strong, nonatomic) NSString *chapterID;
@property (strong, nonatomic) NSString *alias;
@end
