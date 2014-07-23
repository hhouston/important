//
//  MapTableViewCell.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/22/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 40;
    frame.size.width -= 2 * 40;
    [super setFrame:frame];
}

@end
