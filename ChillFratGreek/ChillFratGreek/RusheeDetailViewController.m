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
    
    [self.additionalInfoView.layer setCornerRadius:5.0];
    
    PFFile *thumbnail = self.rusheeObj[@"avatar"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *avatar = [UIImage imageWithData:data];
        self.rusheeProfilePic.image = avatar;
        
    }];
    
    self.rusheeProfilePic.image = [UIImage imageNamed:@"user"];
    
    
    NSLog(@"object did pass name: %@",self.rusheeObj[@"firstName"]);
    self.title = [self.rusheeObj objectForKey:@"firstName"];
    self.rusheeFirstName.text = self.rusheeObj[@"firstName"];
    self.rusheeLastName.text = self.rusheeObj[@"lastName"];
    self.hometown.text = self.rusheeObj[@"hometown"];
    self.cellPhoneNumber.text = self.rusheeObj[@"cellPhone"];
    self.additionalInfo.text = self.rusheeObj[@"additionalInfo"];

    //self.rusheeObj =
    // Do any additional setup after loading the view from its nib.
}

-(void)setReceiveObject:(PFObject *)obj {
    self.rusheeObj = obj;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
