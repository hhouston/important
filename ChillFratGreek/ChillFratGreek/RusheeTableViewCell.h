//
//  RusheeTableViewCell.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/29/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RusheeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rusheeImageView;
@property (weak, nonatomic) IBOutlet UILabel *rusheeFirstName;
@property (weak, nonatomic) IBOutlet UILabel *rusheeLastName;
@property (weak, nonatomic) IBOutlet UIImageView *chatBubbleImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberCommentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *upVoteButton;
@property (weak, nonatomic) IBOutlet UIButton *downVoteButton;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;

@end
