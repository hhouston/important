//
//  SignUpViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *passcode;
@property (strong, nonatomic) IBOutlet UITextField *chapterCode;
- (IBAction)signUpAction:(id)sender;


@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *chapterID;

@end
