//
//  ChatViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 8/12/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewController.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupChatBackgroundView];
    [self setupChatTableViewController];
    NSString *alias = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSLog(@"alias:%@",alias);
    // Do any additional setup after loading the view from its nib.
}

-(void)setupChatBackgroundView {
    
    _chatBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //chatBackgroundView.center = CGPointMake(self.view.frame.size.width / 2, 250);
    
    //chatBackgroundView.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.7];
    _chatBackgroundView.backgroundColor = [UIColor whiteColor];
    _chatBackgroundView.layer.cornerRadius = 2.0;
    _chatBackgroundView.alpha = .9;
    //chatBackgroundView.layer.cornerRadius = 5;
    _chatBackgroundView.layer.masksToBounds = YES;
    //chatBackgroundView.layer.borderColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:1.0].CGColor;
    //chatBackgroundView.layer.borderWidth = 4.0;
    [self.view addSubview:_chatBackgroundView];
}

- (void)setupChatTableViewController {
    //ChatTableViewController *chatTableViewController = [[ChatTableViewController alloc] init];
    //[self.view addSubview:chatTableViewController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
