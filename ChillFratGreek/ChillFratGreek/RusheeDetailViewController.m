//
//  RusheeDetailViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/9/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "RusheeDetailViewController.h"

@interface RusheeDetailViewController ()

@end

@implementation RusheeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"object did pass name: %@",self.rusheeObj[@"name"]);
    self.title = self.rusheeObj[@"name"];
    //self.rusheeObj =
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
