//
//  RusheeObject.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/30/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RusheeObject : NSObject

@property (strong, nonatomic) UIImage *rusheeAvatar;
@property (strong, nonatomic) NSString *rusheeFirstName;
@property (strong, nonatomic) NSString *rusheeLastName;
@property (assign, nonatomic) NSUInteger numberComments;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *users;
@property (assign, nonatomic) NSUInteger voteCount;

@end
