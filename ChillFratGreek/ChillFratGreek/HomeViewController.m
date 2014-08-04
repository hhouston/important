//
//  ViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "HomeViewController.h"
#import "NavigationController.h"
#import "ProfileObject.h"
#import <Parse/Parse.h>
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "STTwitter.h"
#import <Twitter/Twitter.h>
#import "PageViewController.h"
#import "WhiteboardViewController.h"
#import "ProgressHUD.h"
#import "SWRevealViewController/SWRevealViewController.h"
#import "ChatTableViewCell.h"
#import "ChatTableViewController.h"
#import "MessageObject.h"

#define pageCount 3.0
@interface HomeViewController () <SKRequestDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    WhiteboardViewController *cvc;
    CGFloat height;
    NSString *text;
    NSMutableArray *messages;
    NSUInteger numberOfObjects;
    NSUInteger objectCounter;
}

@property (nonatomic,strong)NSArray* fetchedProfilesArray;
@property (strong, nonatomic) NSMutableArray *twitterFeed;
@property (strong, strong) NSMutableArray *scrollViews;

@end

@implementation HomeViewController {
    UIScrollView *twitterScrollView;
    UIScrollView *chatBottomScrollView;
    UIScrollView *pageScrollView;
    UIPageControl *pageControl;
    BOOL tweetsLoaded;
    UIImageView *imageView;
    
    UIImage *menuImage;
    UIImage *settingsImage;
    NSMutableArray *messageArray;
    CGRect tableViewFrame;
    UIView *chatBackgroundView;
    //ChatTableViewController *tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tweetsLoaded = false;
    //self.navigationController.title = @"chat";
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 5.0f;
    style.headIndent = 5.0f;
    //style.tailIndent = 1.0f;
    
    
    
    //UIFont *labelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:14 ];
    
    //    NSDictionary *arialdict = [NSDictionary dictionaryWithObject:labelFont forKey:NSFontAttributeName];
    //    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"this is just the sample example of how to calculate the dynamic height for tableview cell which is of around 7 to 8 lines."attributes:@{NSParagraphStyleAttributeName: style}];
    //    [message addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [message length])];
    //
    //    messageArray = [NSMutableArray arrayWithObjects:message, nil];
    //    NSMutableAttributedString *message_1 = [[NSMutableAttributedString alloc] initWithString:@"you will" attributes:@{NSParagraphStyleAttributeName: style}];
    //    [message_1 addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [message_1 length])];
    //
    //    NSMutableAttributedString *message3 = [[NSMutableAttributedString alloc] initWithString:@"hey this is the 3rd text"attributes:@{NSParagraphStyleAttributeName: style}];
    //    [message3 addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [message3 length])];
    //
    //    NSMutableAttributedString *message4 = [[NSMutableAttributedString alloc] initWithString:@"4th text hippopotamaus right here testing testing testing this is a long sentence write somethings else......"attributes:@{NSParagraphStyleAttributeName: style}];
    //    [message4 addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [message4 length])];
    //
    //    NSMutableAttributedString *message5 = [[NSMutableAttributedString alloc] initWithString:@"5th test text here is some things i am writing and whatnot keep going type type type type type type type type type here is more text to test the text tester testinggggggg"attributes:@{NSParagraphStyleAttributeName: style}];
    //    [message5 addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [message5 length])];
    //
    //    NSMutableAttributedString *message6 = [[NSMutableAttributedString alloc] initWithString:@"hey hey hey hey hey"attributes:@{NSParagraphStyleAttributeName: style}];
    //    [message6 addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [message6 length])];
    //
    //    [messageArray addObject:message_1];
    //    [messageArray addObject:message3];
    //    [messageArray addObject:message4];
    //    [messageArray addObject:message5];//[self loadTweets];
    //    [messageArray addObject:message6];
    
    
    
    
    
    
    
    
    
    messages = [[NSMutableArray alloc] init];
    UIFont *labelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:14 ];
    
    
    //fetch messages
    PFQuery *query = [PFQuery queryWithClassName:@"chats"];
    [query whereKey:@"chapterID" equalTo:self.chapterID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        numberOfObjects = objects.count;
        objectCounter = 0;
        
        if (!error) {
            
            NSLog(@"Successfully retrieved %lu messages.", (unsigned long)objects.count);
            
            for (PFObject *object in objects) {
                objectCounter++;
                //NSLog(@"%@", object.objectId);
                //NSLog(@"LOCATION:%@",object[@"location"]);
                MessageObject *messageObj = [[MessageObject alloc] init];
                NSString *message = object[@"text"];
                
                NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSParagraphStyleAttributeName: style}];
                //[attributedMessage addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [attributedMessage length])];
                
                
                
                
                messageObj.message = attributedMessage;
                messageObj.user = object[@"user"];
                messageObj.timestamp = object[@"createdAt"];
                [messages addObject:messageObj];
                if (objectCounter == numberOfObjects) {
                    [self.chatTableView reloadData];
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
        //[self.overlay_ performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
    
    
    
    
    
    
    
    
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"chapter", @"college", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(0, 90, 100, 20);
    //segmentedControl.center = CGPointMake(self.view.frame.size.width / 2,0);
    //segmentedControl.backgroundColor = [UIColor blueColor];
    //segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    //[[self navigationItem] setTitleView:segmentedControl];
    //[self.view addSubview:segmentedControl];
    
    //imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //imageView.image = [UIImage imageNamed:@"Phi_Gam"];
    //imageView.center = CGPointMake(self.view.frame.size.width / 2, 120);
    
    //imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //imageView.contentMode = UIViewContentModeCenter;
    //[self.view addSubview:imageView];
    
    chatBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //chatBackgroundView.center = CGPointMake(self.view.frame.size.width / 2, 250);
    
    //chatBackgroundView.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.7];
    chatBackgroundView.backgroundColor = [UIColor whiteColor];
    chatBackgroundView.layer.cornerRadius = 2.0;
    chatBackgroundView.alpha = .9;
    //chatBackgroundView.layer.cornerRadius = 5;
    chatBackgroundView.layer.masksToBounds = YES;
    //chatBackgroundView.layer.borderColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:1.0].CGColor;
    //chatBackgroundView.layer.borderWidth = 4.0;
    [self.view addSubview:chatBackgroundView];
    //tableView = [[ChatTableViewController alloc] init];
    
    //self.view.backgroundColor = [UIColor colorWithRed:189.0/255 green:190.0/255 blue:194.0/255 alpha:1.0];
    //
    //    SWRevealViewController *revealController = self.revealViewController;
    //    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    //        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:revealController action:@selector(rightRevealToggle:)];
    //        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    //        [self.view addGestureRecognizer:swipeLeft];
    
    
    
    menuImage = [[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:(NavigationController *)self.navigationController action:@selector(showMenu)];
    
    
    settingsImage = [[UIImage imageNamed:@"cogs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:(NavigationController *)self.navigationController action:@selector(showSettings)];
    //
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
    //                                                                             style:UIBarButtonItemStylePlain
    //                                                                            target:self
    //                                                                            action:@selector(showMenu)];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    tableViewFrame = CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height-100);
    [self setUpTableView];
}

-(void)setUpTableView {
    //    //CGRect tableViewFrame = CGRectMake(0, -height, 0, height);
    
    self.chatTableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.chatTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    //self.chatTableView.contentInset = UIEdgeInsetsMake(40, 40, 40, 0);
    //[self.chatTableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    //self.chatTableView.alpha = .70;
    //self.chatTableView.backgroundColor = [UIColor redColor];
    //self.chatTableView.alpha = .7;
    self.chatTableView.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.9];
    //self.overlay_.backgroundColor = HEXCOLOR(663399);
    [chatBackgroundView addSubview:self.chatTableView];
    //
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return YES;
}
//- (void)viewWillAppear:(BOOL)animated {
//[super viewWillAppear:animated];

// 4
//CGSize pagesScrollViewSize = pageScrollView.frame.size;
//pageScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageCount, pagesScrollViewSize.height);

// 5
//[self loadVisiblePages];
//}

- (void)loadPageScrollView {
    
    
    int numberOfPages = pageCount;
    pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                                    self.view.frame.size.height)];
    [pageScrollView setContentSize:CGSizeMake(numberOfPages*pageScrollView.frame.size.width, pageScrollView.frame.size.height)];
    [pageScrollView setPagingEnabled:YES];
    [pageScrollView setShowsHorizontalScrollIndicator:NO];
    [pageScrollView setDelegate:self];
    [self.view addSubview:pageScrollView];
    
    //y val - pageScrollView.frame.size.height-30
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageScrollView.frame.size.height-180, pageScrollView.frame.size.width, 20)];
    [pageControl setNumberOfPages:numberOfPages];
    //pageControl.backgroundColor = [UIColor blueColor];
    [pageControl setCurrentPage:0];
    [self.view addSubview:pageControl];
    
    [self loadTwitterScrollView];
    //    for (int i=0; i<numberOfPages; i++) {
    //        CGRect frame = pageScrollView.frame;
    //        frame.origin.x = frame.size.width * i;
    //        frame.origin.y = 0;
    //        //UIView *view = [[UIView alloc] initWithFrame:frame];
    //        //Setup your view
    //        //[pageScrollView addSubview:view];
    //    }
    
    
}


#pragma mark - Twitter Methods
- (void)loadTwitterScrollView{
    
    if (twitterScrollView == nil ) {
        twitterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pageScrollView.frame.size.width, 418, self.view.frame.size.width, 150)];
        twitterScrollView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(188/255.0) alpha:.7];
        twitterScrollView.pagingEnabled = NO;
        twitterScrollView.delegate = self;
        
        
        
    }
    //lets create 10 views
    //NSInteger numberOfViews = 10;
    for (NSInteger i = 0; i < self.twitterFeed.count; i++) {
        
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
    twitterScrollView.contentSize = CGSizeMake(135 * (self.twitterFeed.count) + 5,
                                               100);
    
    
    NSLog(@"HVC--------alias: %@\nchapterID:%@", self.alias, self.chapterID);
    
    [twitterScrollView removeFromSuperview];
    
    [self.view addSubview:twitterScrollView];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = pageScrollView.frame.size.width;
    int page = floor((pageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //    NSLog(@"twitterScrollView offset.x:%f", twitterScrollView.contentOffset.x);
    //    if (twitterScrollView.contentOffset.x > self.twitterFeed.count*135-pageScrollView.frame.size.width ) {
    //
    //        [twitterScrollView setContentSize:CGSizeMake(150 * (self.twitterFeed.count+4), 100)];
    //        //[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x-((29+70)*36),  0)];
    //    }
    //NSLog(@"pageScrollView offset.x:%f", pageScrollView.contentOffset.x);
    
    if (pageScrollView.contentOffset.x > 760){
        [pageScrollView setContentOffset:CGPointMake(0, 0)];
    }
    //    if (pageControl.currentPage != page && page == 1) {
    //        [self loadTweets];
    //    }
    pageControl.currentPage = page;
    
    if (pageScrollView.contentOffset.x >= pageWidth * 2){
        //NSLog(@"page3");
        
    } else if (pageScrollView.contentOffset.x >= pageWidth){
        NSLog(@"page2");
        
    } else if (pageScrollView.contentOffset.x == 0) {
        NSLog(@"page1");
    }
}


- (void)loadTweets {
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"Q9ywjYkSqI8WGObMP3GyA556t" consumerSecret:@"VZV3u6JprnGZKZ2de96PwdiSEEuHSbxvEu8c7YAb5zUBmjebuV"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        [twitter getUserTimelineWithScreenName:@"TotalFratMove" successBlock:^(NSArray *statuses) {
            [self.twitterFeed removeAllObjects];
            self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
            //[self tweetsLoaded];
            [self loadTwitterScrollView];
            
        } errorBlock:^(NSError *error) {
            NSLog(@"getUserTimeline ERROR");
            NSLog(@"%@", error.debugDescription);
        }];
        
        
        
    } errorBlock:^(NSError *error) {
        NSLog(@"verify credentials ERROR");
        NSLog(@"%@", error.debugDescription);
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)valueChanged:(UISegmentedControl *)segment {
    
    if(segment.selectedSegmentIndex == 0) {
        //action for the first button (All)
    }else if(segment.selectedSegmentIndex == 1){
        //action for the second button (Present)
    }else if(segment.selectedSegmentIndex == 2){
        //action for the third button (Missing)
    }
}

//- (PFQuery *)queryForTable {
//    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//    NSLog(@"chapterID: %@", self.chapterID);
//    [query whereKey:@"chapterID" equalTo:self.chapterID];
//
//    // If no objects are loaded in memory, we look to the cache first to fill the table
//    // and then subsequently do a query against the network.
//    if (self.objects.count == 0) {
//        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    }
//
//    [query orderByDescending:@"createdAt"];
//
//    return query;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [messages count];
    return 19;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatTableViewCell" owner:nil options:nil] objectAtIndex:0];
        //cell.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.3];
        //cell.layer.cornerRadius = 5.0;
        //cell.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.7];
        
        //cell.backgroundColor = [UIColor blackColor];
        [cell setClipsToBounds:YES];
        //cell.backgroundColor = [UIColor clearColor];
        //cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    }
    //CGRect frame;
    //[cell setFrame:frame];
    //CGSize sizeDynamic  = [[messageArray objectAtIndex:indexPath.row] sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (messages.count != 0) {
        cell.avatar.image = [UIImage imageNamed:@"avatar.jpg"];
        cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        cell.avatar.layer.masksToBounds = YES;
        cell.avatar.layer.cornerRadius = 3.0;
        //cell.avatar.layer.borderColor = [UIColor grayColor].CGColor;
        //cell.avatar.layer.borderWidth = 2.0f;
        cell.avatar.layer.rasterizationScale = [UIScreen mainScreen].scale;
        cell.avatar.layer.shouldRasterize = YES;
        cell.avatar.clipsToBounds = YES;
        [cell.upVoteButton addTarget:self action:@selector(pressedUp:) forControlEvents:UIControlEventTouchUpInside];//[cell.upVoteButton performSelector:@selector(pressedUp:) withObject:[NSNumber numberWithInt:(int)indexPath.row]];

        //[cell.upVoteButton addTarget:self action:@selector(pressedUp:) withObject:[NSNumber numberWithInt:(int)indexPath.row ]];
        //cell.textLabel.text = [messageArray objectAtIndex:indexPath.row];
        //cell.textLabel.frame = CGRectMake(20,20,200,800);
        
        //UIButton *upButton = [[UIButton alloc]init];//
        //upButton.frame=CGRectMake(268, 0, 33, 44);
        //upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[upButton setImage:[UIImage imageNamed:@"arrow-up-20x.png"] forState:UIControlStateNormal];
        //[upButton addTarget:self action:@selector(pressedUp:) withObject:[messages objectAtIndex:indexPath.row] ];
        //[upButton performSelector:@selector(pressedUp:) withObject:[NSNumber numberWithInt:(int)indexPath.row]];
        //[self performSelectorOnMainThread:@selector(pressedUp:) withObject:[NSNumber numberWithInt:(int)indexPath] waitUntilDone:NO];

        //[cell.contentView addSubview:upButton];
        
        
        
        
        
        
        
        //[upButton performSelector:@selector(pressedUp:) withObject:[NSNumber numberWithInt:(int)indexPath.row]];
        
        
        [cell.textLabel sizeToFit];
        //frame.origin.x = 10; //move the frame over..this adds the padding!
        //frame.size.width = self.view.bounds.size.width - frame.origin.x;
        //cell.textLabel.textColor = [UIColor whiteColor];
        //cell.textLabel.alpha = .9;
        //cell.textLabel.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.90];
        //cell.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20,sizeDynamic.width,sizeDynamic.height)];
        
        //cell.textLabel
        //cell.textLabel.textAlignment = NSTextAlignmentNatural;
        
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.layer.cornerRadius = 3.0f;
        MessageObject *tempMessageObject = [messages objectAtIndex:indexPath.row];
        cell.textLabel.attributedText = tempMessageObject.message;
        //[messages addObject:object];
        //cell.textLabel.attributedText = [messages objectAtIndex:indexPath.row];
        
        
        // dont calculate height hear it will be called after "heightForRowAtIndexPath" method
        cell.textLabel.numberOfLines = 0;
        //height = CGRectGetHeight(cell.textLabel.bounds);
        cell.textLabel.textColor = [UIColor blackColor];
    } else {
        //self.view.backgroundColor = [UIColor blackColor];
    }
    return cell;
}

-(void)pressedUp:(NSNumber *)indexPath {
    NSLog(@"index path:%@",indexPath);
}

-(float)height :(NSMutableAttributedString*)string
{
    
    NSAttributedString *attributedText = string;
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){301, MAXFLOAT}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];//you need to specify the some width, height will be calculated
    CGSize requiredSize = rect.size;
    
    return requiredSize.height; //finally u return your height
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    //    if (indexPath.row == 0) {
    //        return 50;
    //    }
    //    if (indexPath.row == 1) {
    //        return 50;
    //    }
    //
    //    return 50;
    //whatever the height u need to calculate calculate hear only
    
    if (messages.count == 0) {
        return 0;
    } else {
        MessageObject *tempObj = [messages objectAtIndex:indexPath.row];
        NSAttributedString *string = tempObj.message;
        CGFloat heightOfcell = [self height:(NSMutableAttributedString*)string];
        NSLog(@"%f",heightOfcell);
        
        return heightOfcell+50;
    }
    return 50;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
}



@end
