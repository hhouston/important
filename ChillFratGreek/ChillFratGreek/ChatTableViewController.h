//
//  ChatTableViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/24/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ChatTableViewController : UIViewController
@property (nonatomic, strong) NSString *chapterID;

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, assign) CGRect tableViewFrame;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *upVotedArray;
@property (nonatomic) CGRect resizableLable;

@end
