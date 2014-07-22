//
//  PageViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/17/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//
#import "PageViewController.h"
#import "PollViewController.h"
#import "WhiteboardViewController.h"
#import "TweetViewController.h"
#import "HomeViewController.h"

@interface PageViewController () {
    
    HomeViewController *hvc;
    
}

@property (strong, nonatomic) WhiteboardViewController *cvc;
@property (strong, nonatomic) TweetViewController *tvc;

@end

@implementation PageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    hvc = [[HomeViewController alloc] init];
    NSLog(@"view #%ld",(long)self.index);
    //self.screenNumber.text = [NSString stringWithFormat:@"Screen #%ld", (long)self.index];
    

    if (self.index == 0)
    {
        NSLog(@"load chatview");
        hvc.title = @"chat";
    } else if (self.index == 1) {
        NSLog(@"load tweets");
        hvc.title = @"tweeter";

        self.title = @"tweets";
        [self loadTweetView];
        
    } else if (self.index == 3) {
        NSLog(@"load polls");
        self.title = @"polls";
        
    }
    
    // Do any additional setup after loading the view.
}


- (void)loadTweetView{
    NSLog(@"load pageview called");
    self.tvc = [[TweetViewController alloc] init];
    //hvc.pageControl.currentPage = 2;
    [self.view addSubview:self.tvc.view];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
