//
//  RusheesTableViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import <Parse/Parse.h>

@interface RusheesTableViewController : PFQueryTableViewController

@property (strong, nonatomic) NSString* chapterID;
@property (strong, nonatomic) NSArray *rusheeObjs;
- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object;
- (PFQuery *)queryForTable;
@end
