//
//  ChatTableViewCell.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/25/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ChatTableViewCell.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"

@interface ChatTableViewCell () {
    NSUInteger voteCounter;
}

@end

@implementation ChatTableViewCell
@synthesize textLabel;

- (void)awakeFromNib
{
    // Initialization code
}
//- (void)setFrame:(CGRect)frame {
//    
//    if (self.superview) {
//        float cellWidth = 290.0;
//        frame.origin.x += 15;
//        frame.size.width = cellWidth;
//    }
//    
//    [super setFrame:frame];
//}

//- (void) layoutSubviews
//{
//    [super layoutSubviews];
//    self.textLabel.frame = CGRectMake(0, 0, 320, 20);
//}

- (void)viewDidLoad {
    voteCounter = nil;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)upVote:(id)sender {



//    PFQuery *query = [PFQuery queryWithClassName:@"chats"];
//    [query whereKey:@"objectID" equalTo:self.chapterID];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject * rusheeObj, NSError *error) {
//        if (!error) {
//            // Found UserStats
//            //[rusheeObj setObject:self.voteCounter forKey:@"voteCount"];
//            //[userStats setObject:newScore forKey:@"latestScore"];
//            
//            // Save
//            //[userStats saveInBackground];
//        } else {
//            // Did not find any UserStats for the current user
//            NSLog(@"Error: %@", error);
//        }
//    }];
//    
//    if ([self.upVoteButton isSelected]) {
//        
//        [self.upVoteButton setSelected:NO];
//        voteCounter--;
//        
//    } else {
//        
//        [self.upVoteButton setSelected:YES];
//        voteCounter++;
//
//
//    }
    
}

@end
