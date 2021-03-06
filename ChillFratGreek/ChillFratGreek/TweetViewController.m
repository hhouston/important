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






























#pragma mark - Scroll Views (UNUSED AON)

//- (void)viewWillAppear:(BOOL)animated {
//[super viewWillAppear:animated];

// 4
//CGSize pagesScrollViewSize = pageScrollView.frame.size;
//pageScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageCount, pagesScrollViewSize.height);

// 5
//[self loadVisiblePages];
//}

//- (void)loadPageScrollView {
//    
//    
//    int numberOfPages = pageCount;
//    pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
//                                                                    self.view.frame.size.height)];
//    [pageScrollView setContentSize:CGSizeMake(numberOfPages*pageScrollView.frame.size.width, pageScrollView.frame.size.height)];
//    [pageScrollView setPagingEnabled:YES];
//    [pageScrollView setShowsHorizontalScrollIndicator:NO];
//    [pageScrollView setDelegate:self];
//    [self.view addSubview:pageScrollView];
//    
//    //y val - pageScrollView.frame.size.height-30
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageScrollView.frame.size.height-180, pageScrollView.frame.size.width, 20)];
//    [pageControl setNumberOfPages:numberOfPages];
//    //pageControl.backgroundColor = [UIColor blueColor];
//    [pageControl setCurrentPage:0];
//    [self.view addSubview:pageControl];
//    
//    [self loadTwitterScrollView];
//    //    for (int i=0; i<numberOfPages; i++) {
//    //        CGRect frame = pageScrollView.frame;
//    //        frame.origin.x = frame.size.width * i;
//    //        frame.origin.y = 0;
//    //        //UIView *view = [[UIView alloc] initWithFrame:frame];
//    //        //Setup your view
//    //        //[pageScrollView addSubview:view];
//    //    }
//    
//    
//}
//
//
//#pragma mark - Twitter Methods
//- (void)loadTwitterScrollView{
//    
//    if (twitterScrollView == nil ) {
//        twitterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pageScrollView.frame.size.width, 418, self.view.frame.size.width, 150)];
//        twitterScrollView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7];
//        twitterScrollView.pagingEnabled = NO;
//        twitterScrollView.delegate = self;
//        
//        
//        
//    }
//    //lets create 10 views
//    //NSInteger numberOfViews = 10;
//    for (NSInteger i = 0; i < self.twitterFeed.count; i++) {
//        
//        //set the origin of the sub view
//        //CGFloat myOrigin = i * self.view.frame.size.width;
//        CGFloat myOrigin = i * 135 + 5;
//        
//        //create the sub view and allocate memory
//        UIView *tweetView = [[UIView alloc] initWithFrame:CGRectMake(myOrigin, 5, 130, 140)];
//        //set the background to white color
//        tweetView.backgroundColor = [UIColor whiteColor];
//        //tweetView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7];
//        tweetView.layer.cornerRadius = 6.0;
//        //create a label and add to the sub view
//        //UILabel *myLabel = [[UILabel alloc] initWithFrame:myFrame];
//        //myLabel.text = [NSString stringWithFormat:@"This is page number %d", i];
//        NSDictionary *t = self.twitterFeed[i];
//        
//        
//        NSString *aURL = t[@"user"][@"profile_image_url"];
//        //NSLog(@"url:%@",aURL);
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aURL]]];
//        
//        UIImageView *tweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,48,48)];
//        tweetImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        
//        [tweetImageView setImage:image];
//        tweetImageView.layer.masksToBounds = YES;
//        tweetImageView.layer.cornerRadius = 5.0;
//        tweetImageView.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7].CGColor;
//        tweetImageView.layer.borderWidth = 3.0f;
//        tweetImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        tweetImageView.layer.shouldRasterize = YES;
//        tweetImageView.clipsToBounds = YES;
//        [tweetView addSubview:tweetImageView];
//        
//        UILabel *tweeterLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 5, 80, 20)];
//        tweeterLabel.textAlignment = NSTextAlignmentCenter;
//        tweeterLabel.text = @"@TotalFratMove";
//        tweeterLabel.font = [UIFont boldSystemFontOfSize:10.0f];
//        tweeterLabel.textColor = [UIColor blackColor];
//        [tweetView addSubview:tweeterLabel];
//        
//        CGRect myFrame = CGRectMake(10.0f, 50.0f, 100.0f, 80.0f);
//        UILabel *tweetLabel = [[UILabel alloc] initWithFrame:myFrame];
//        tweetLabel.text = t[@"text"];
//        
//        NSInteger lines = 5;
//        tweetLabel.numberOfLines = lines;
//        tweetLabel.font = [UIFont boldSystemFontOfSize:11.0f];
//        tweetLabel.textColor = [UIColor blackColor];
//        tweetLabel.textAlignment =  NSTextAlignmentLeft;
//        [tweetView addSubview:tweetLabel];
//        
//        
//        //set the scroll view delegate to self so that we can listen for changes
//        //self.twitterScrollView.delegate = self;
//        //add the subview to the scroll view
//        [twitterScrollView addSubview:tweetView];
//    }
//    
//    //set the content size of the scroll view, we keep the height same so it will only
//    //scroll horizontally
//    twitterScrollView.contentSize = CGSizeMake(135 * (self.twitterFeed.count) + 5,
//                                               100);
//    
//    
//    NSLog(@"HVC--------alias: %@\nchapterID:%@", self.alias, self.chapterID);
//    
//    [twitterScrollView removeFromSuperview];
//    
//    [self.view addSubview:twitterScrollView];
//    
//}
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    CGFloat pageWidth = pageScrollView.frame.size.width;
//    int page = floor((pageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    
//    //    NSLog(@"twitterScrollView offset.x:%f", twitterScrollView.contentOffset.x);
//    //    if (twitterScrollView.contentOffset.x > self.twitterFeed.count*135-pageScrollView.frame.size.width ) {
//    //
//    //        [twitterScrollView setContentSize:CGSizeMake(150 * (self.twitterFeed.count+4), 100)];
//    //        //[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x-((29+70)*36),  0)];
//    //    }
//    //NSLog(@"pageScrollView offset.x:%f", pageScrollView.contentOffset.x);
//    
//    if (pageScrollView.contentOffset.x > 760){
//        [pageScrollView setContentOffset:CGPointMake(0, 0)];
//    }
//    //    if (pageControl.currentPage != page && page == 1) {
//    //        [self loadTweets];
//    //    }
//    pageControl.currentPage = page;
//    
//    if (pageScrollView.contentOffset.x >= pageWidth * 2){
//        //NSLog(@"page3");
//        
//    } else if (pageScrollView.contentOffset.x >= pageWidth){
//        NSLog(@"page2");
//        
//    } else if (pageScrollView.contentOffset.x == 0) {
//        NSLog(@"page1");
//    }
//}
//
//
//- (void)loadTweets {
//    
//    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"Q9ywjYkSqI8WGObMP3GyA556t" consumerSecret:@"VZV3u6JprnGZKZ2de96PwdiSEEuHSbxvEu8c7YAb5zUBmjebuV"];
//    
//    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
//        
//        [twitter getUserTimelineWithScreenName:@"TotalFratMove" successBlock:^(NSArray *statuses) {
//            [self.twitterFeed removeAllObjects];
//            self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
//            //[self tweetsLoaded];
//            [self loadTwitterScrollView];
//            
//        } errorBlock:^(NSError *error) {
//            NSLog(@"getUserTimeline ERROR");
//            NSLog(@"%@", error.debugDescription);
//        }];
//        
//        
//        
//    } errorBlock:^(NSError *error) {
//        NSLog(@"verify credentials ERROR");
//        NSLog(@"%@", error.debugDescription);
//        
//    }];
//}


@end
