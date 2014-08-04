//
//  LogInViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *passcode;

-(IBAction)textFieldReturn:(id)sender;

//@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *chapterID;
@property (strong, nonatomic) NSArray *rusheeObjs;

@end
