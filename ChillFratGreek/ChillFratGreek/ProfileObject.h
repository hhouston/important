//
//  ProfileObject.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/12/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
@interface ProfileObject : NSObject

@property (strong, nonatomic) NSString *chapterID;
@property (strong, nonatomic) NSString *collegeID;
@property (strong, nonatomic) NSString *fraternityName;
@property (strong, nonatomic) NSString *schoolName;
@property (strong, nonatomic) NSString *userAlias;
@property (strong, nonatomic) PFImageView *avatar;

@end
