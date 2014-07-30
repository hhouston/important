//
//  RusheeDetailViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/9/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RusheeDetailViewController : UIViewController

@property (strong, nonatomic) PFObject *rusheeObj;
-(void)setReceiveObject:(PFObject *)obj;
@property (weak, nonatomic) IBOutlet UIImageView *rusheeProfilePic;
@property (weak, nonatomic) IBOutlet UIImageView *indicdentIndicator;
@property (weak, nonatomic) IBOutlet UILabel *rusheeFirstName;
@property (weak, nonatomic) IBOutlet UILabel *rusheeLastName;
@property (weak, nonatomic) IBOutlet UILabel *hometown;
@property (weak, nonatomic) IBOutlet UILabel *cellPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *additionalInfo;
@property (weak, nonatomic) IBOutlet UIView *additionalInfoView;
@property (weak, nonatomic) IBOutlet UIButton *downVote;
@property (weak, nonatomic) IBOutlet UIButton *upVote;
@property (weak, nonatomic) IBOutlet UILabel *voteCount;

@end
