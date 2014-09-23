//
//  ChatTableViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/24/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatTableViewCell.h"
#import "MessageObject.h"

@interface ChatTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIView *chatBackgroundView;
    CGFloat height;
    NSString *text;
    int indexCounter;
    int queryObjectsIndex;
    
    NSUInteger numberOfObjects;
//    NSMutableParagraphStyle *style;
//    UIFont *labelFont;
}

@end

@implementation ChatTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.chapterID = [[NSUserDefaults standardUserDefaults] objectForKey:@"chapterID"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    //CGRect frame = self.view.frame;
    //frame.origin.y += 64.0;
    //frame.size.height -= 100.0;
    //self.tableViewFrame = frame;
    self.tableViewFrame = CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height-64);
    [self setupChatBackgroundView];
    //[self setUpTableView];
}

-(void)setupChatBackgroundView {
    chatBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //chatBackgroundView.center = CGPointMake(self.view.frame.size.width / 2, 250);
    
    //chatBackgroundView.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.7];
    chatBackgroundView.backgroundColor = [UIColor whiteColor];
    //chatBackgroundView.layer.cornerRadius = 5.0;
    chatBackgroundView.alpha = .9;
    //chatBackgroundView.layer.cornerRadius = 5;
    chatBackgroundView.layer.masksToBounds = YES;
    //chatBackgroundView.layer.borderColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:1.0].CGColor;
    //chatBackgroundView.layer.borderWidth = 4.0;
    [self.view addSubview:chatBackgroundView];
    [self setUpTableView];
}


-(void)setUpTableView {
    //CGRect tableViewFrame = CGRectMake(0, -height, 0, height);
    self.chatTableView = [[UITableView alloc] initWithFrame:self.tableViewFrame];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.chatTableView.layer.cornerRadius = 5.0;
    self.chatTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.chatTableView.alpha = .90;
    //self.overlay_.backgroundColor = [UIColor clearColor];
    //self.overlay_.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.9];
    //self.overlay_.backgroundColor = HEXCOLOR(663399);
    [self.view addSubview:self.chatTableView];
    [self retrieveFromParse];
}

#pragma mark - Parse

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"chats"];
    [query whereKey:@"chapterID" equalTo:self.chapterID];
    [query orderByDescending:@"createdAt"];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.messages count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    
    return query;
}

-(void) retrieveFromParse {
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    UIFont *labelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:14 ];
    
    //style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 5.0f;
    style.headIndent = 5.0f;
    
    self.upVotedArray = [[NSMutableArray alloc] init];
    self.messages = [[NSMutableArray alloc] init];
    
    [[self queryForTable] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        numberOfObjects = objects.count;
        indexCounter = 0;

        if(!error) {
            for (PFObject *object in objects) {

            MessageObject *tempMessageObject = [[MessageObject alloc] init];
            self.upVotedArray = object[@"upVoted"];

           // self.messages = [[NSMutableArray alloc] initWithArray:objects];
            
                if (object[@"text"] == nil) {
                    
                    object[@"text"] = @"nil";
                    
                }
                NSString *message = object[@"text"];
                
                NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSParagraphStyleAttributeName: style}];
                
                [attributedMessage addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [attributedMessage length])];
                
                tempMessageObject.message = attributedMessage;
                tempMessageObject.type = @"text";
                
                
                tempMessageObject.user = object[@"user"];
                tempMessageObject.timestamp = object[@"createdAt"];
                //messageObj.voteCount = [[object objectForKey:@"voteCount"] integerValue];
                //tempMessageObject.voteCount = self.upVotedArray.count;
                
//                for (int i = 0; i < self.upVotedArray.count; i++) {
//                    if( [[PFUser currentUser].objectId isEqualToString:[self.upVotedArray objectAtIndex:i]] ) {
//                        tempMessageObject.selected = YES;
//                    }
//                }
                
                [self.messages addObject:tempMessageObject];
                indexCounter++;
           // } else {
            //    break;
            //}
            }
            
            if (indexCounter == numberOfObjects) {
                    //imageButtonCounter = 0;
                    [self.chatTableView reloadData];
                    //NSIndexPath *lastMessageIP = [NSIndexPath indexPathForRow:objects.count-1 inSection:0];
                    //[self.chatTableView scrollToRowAtIndexPath:lastMessageIP atScrollPosition:NULL animated:YES];
                    
//                    if (imageSent == YES) {
//                        [self finishImageProgressBar];
//                        imageSent = NO;
//                    } else if (textSent == YES) {
//                        [self finishImageProgressBar];
//                        textSent = NO;
//                    }
                
                }
            [self.chatTableView reloadData];
            }

        
    }];
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
        cell.backgroundColor = [UIColor clearColor];
        [cell setClipsToBounds:YES];
        //cell.backgroundColor = [UIColor clearColor];
        //cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    }
    
    cell.textLabel.backgroundColor = [UIColor orangeColor];
    cell.textLabel.layer.cornerRadius = 3.0f;
    MessageObject *tempMessageObject = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.attributedText = tempMessageObject.message;
    [cell.voteCount setText:[NSString stringWithFormat:@"%lu",(unsigned long)tempMessageObject.voteCount]];
    
//    PFObject *tempMessage = [self.messages objectAtIndex:indexPath.row];
//    NSLog(@"TEXT:%@",tempMessage[@"text"]);
//
//    cell.textLabel.text = tempMessage[@"text"];
    [cell.textLabel sizeToFit];
    height = cell.textLabel.bounds.size.height;
    NSLog(@"height:%f",height);
    return cell;
}

# pragma height for row

-(float)height :(NSMutableAttributedString*)string
{
    if (string == nil) {
        return 130;
    }
    NSAttributedString *attributedText = string;
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){280, MAXFLOAT}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];//you need to specify the some width, height will be calculated
    CGSize requiredSize = rect.size;
    
    return requiredSize.height; //finally u return your height
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (indexPath.row == 0) {
    //        return 50;
    //    }
    //    if (indexPath.row == 1) {
    //        return 50;
    //    }
    //
    //    return 50;
    //whatever the height u need to calculate calculate hear only
    
    if (_messages.count == 0) {
        return 0;
    } else {
        MessageObject *tempObj = [_messages objectAtIndex:indexPath.row];
        NSAttributedString *string = tempObj.message;
        CGFloat heightOfcell = [self height:(NSMutableAttributedString*)string];
        //NSLog(@"%f",heightOfcell);
        
        return heightOfcell+50;
    }
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
