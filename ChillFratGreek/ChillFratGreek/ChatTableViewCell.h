//
//  ChatTableViewCell.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/25/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *voteCount;
@property (weak, nonatomic) IBOutlet UIButton *upVoteButton;
@property (assign, nonatomic) NSNumber *voteCounter;

- (IBAction)upVote:(id)sender;

@property (strong, nonatomic) NSString *chapterID;
@property (nonatomic) float requiredCellHeight;


@end
