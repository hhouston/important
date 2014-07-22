//
//  ViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "REFrostedViewController.h"
#import "JSQMessages.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic) NSString *alias;
@property (strong, nonatomic) NSString *chapterID;
@property (assign, nonatomic) NSInteger index;

@end
