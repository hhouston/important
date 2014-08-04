//
//  CheckLoginViewController.h
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/13/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckLoginViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) NSString *chapterID;
@property (nonatomic, strong) NSString *alias;

@end
