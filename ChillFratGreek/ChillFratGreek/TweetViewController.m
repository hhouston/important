//
//  TweetViewController.m
//  TestPageController
//
//  Created by Hunter Houston on 7/17/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "TweetViewController.h"
#import "STTwitter/STTwitter.h"

@interface TweetViewController () {
    UIScrollView *twitterScrollView;
}

@property (strong, nonatomic) NSMutableArray *twitterFeed;
@end

@implementation TweetViewController

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
    self.title = @"tweeter";
    [self loadTweets];
    // Do any additional setup after loading the view.
}

- (void)loadTweets {
    
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"Q9ywjYkSqI8WGObMP3GyA556t" consumerSecret:@"VZV3u6JprnGZKZ2de96PwdiSEEuHSbxvEu8c7YAb5zUBmjebuV"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        [twitter getUserTimelineWithScreenName:@"TotalFratMove" successBlock:^(NSArray *statuses) {
            
            self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
            [self loadScrollView];
            
        } errorBlock:^(NSError *error) {
            NSLog(@"getUserTimeline ERROR");
            NSLog(@"%@", error.debugDescription);
        }];
        
        
        
    } errorBlock:^(NSError *error) {
        NSLog(@"verify credentials ERROR");
        NSLog(@"%@", error.debugDescription);
        
    }];
}

- (void)loadScrollView {
    //initialize and allocate your scroll view
    twitterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 418, self.view.frame.size.width, 150)];
    twitterScrollView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7];
    twitterScrollView.pagingEnabled = NO;
    
    NSInteger numberOfViews = 10;
    for (NSInteger i = 0; i < numberOfViews; i++) {
        
        //set the origin of the sub view
        //CGFloat myOrigin = i * self.view.frame.size.width;
        CGFloat myOrigin = i * 135 + 5;
        
        //create the sub view and allocate memory
        UIView *tweetView = [[UIView alloc] initWithFrame:CGRectMake(myOrigin, 5, 130, 140)];
        //set the background to white color
        tweetView.backgroundColor = [UIColor whiteColor];
        //tweetView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7];
        tweetView.layer.cornerRadius = 6.0;
        //create a label and add to the sub view
        //UILabel *myLabel = [[UILabel alloc] initWithFrame:myFrame];
        //myLabel.text = [NSString stringWithFormat:@"This is page number %d", i];
        NSDictionary *t = self.twitterFeed[i];
        
        
        NSString *aURL = t[@"user"][@"profile_image_url"];
        //NSLog(@"url:%@",aURL);
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aURL]]];
        
        UIImageView *tweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,48,48)];
        tweetImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [tweetImageView setImage:image];
        tweetImageView.layer.masksToBounds = YES;
        tweetImageView.layer.cornerRadius = 5.0;
        tweetImageView.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7].CGColor;
        tweetImageView.layer.borderWidth = 3.0f;
        tweetImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        tweetImageView.layer.shouldRasterize = YES;
        tweetImageView.clipsToBounds = YES;
        [tweetView addSubview:tweetImageView];
        
        UILabel *tweeterLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 5, 80, 20)];
        tweeterLabel.textAlignment = NSTextAlignmentCenter;
        tweeterLabel.text = @"@TotalFratMove";
        tweeterLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        tweeterLabel.textColor = [UIColor blackColor];
        [tweetView addSubview:tweeterLabel];
        
        CGRect myFrame = CGRectMake(10.0f, 50.0f, 100.0f, 80.0f);
        UILabel *tweetLabel = [[UILabel alloc] initWithFrame:myFrame];
        tweetLabel.text = t[@"text"];
        
        NSInteger lines = 5;
        tweetLabel.numberOfLines = lines;
        tweetLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        tweetLabel.textColor = [UIColor blackColor];
        tweetLabel.textAlignment =  NSTextAlignmentLeft;
        [tweetView addSubview:tweetLabel];
        
        
        //set the scroll view delegate to self so that we can listen for changes
        //self.twitterScrollView.delegate = self;
        //add the subview to the scroll view
        [twitterScrollView addSubview:tweetView];
    }
    
    //set the content size of the scroll view, we keep the height same so it will only
    //scroll horizontally
    twitterScrollView.contentSize = CGSizeMake(135 * (numberOfViews),
                                               100);
    
    
    [self.view addSubview:twitterScrollView];
    
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
