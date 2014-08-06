//
//  MessageObject.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/30/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

@property (strong, nonatomic) NSAttributedString *message;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSDate *timestamp;
@property (assign, nonatomic) NSUInteger voteCount;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSMutableArray *upVotersArray;
@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) BOOL selected;
@end
