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
#import <MobileCoreServices/MobileCoreServices.h>

#define pageCount 3.0
#define kOFFSET_FOR_KEYBOARD 215.0
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@interface HomeViewController () <SKRequestDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    
    WhiteboardViewController *cvc;
    CGFloat height;
    NSString *text;
    NSMutableArray *messages;
    NSUInteger numberOfObjects;
    NSUInteger objectCounter;
    NSUInteger voteCounter;
    NSNumber *voteCount;
    NSMutableArray *upVotedArray;
    UITextField *textField;
    BOOL up;
    CGFloat animatedDistance;
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
    UIButton *button;
    UIView *navBar;
    BOOL viewLoaded;
    
    NSMutableArray *attachments;
}

@property (nonatomic,strong)NSArray* fetchedProfilesArray;
@property (strong, nonatomic) NSMutableArray *twitterFeed;
@property (strong, strong) NSMutableArray *scrollViews;

@end

@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    up = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [self getMessages];
    [self chatBackgroundView];
    [self navBar];
    
    //[self setupMessageTextView];
    
    //fiji badge
    //imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //imageView.image = [UIImage imageNamed:@"Phi_Gam"];
    //imageView.center = CGPointMake(self.view.frame.size.width / 2, 120);
    //imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //imageView.contentMode = UIViewContentModeCenter;
    //[self.view addSubview:imageView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //NSIndexPath *lastMessageIP = [NSIndexPath indexPathForRow:numberOfObjects-1 inSection:0] ;
    
    [self getMessages];
    //[self.chatTableView scrollToRowAtIndexPath:lastMessageIP atScrollPosition:NULL animated:YES];
    
    if (viewLoaded == NO) {
        
        tableViewFrame = CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height-104);
        [self setUpTableView];
        viewLoaded = YES;
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:(BOOL)animated];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textFieldEdit
{
    navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navBar.backgroundColor = [UIColor whiteColor];
    navBar.layer.cornerRadius = 2.0;
    //navBar.backgroundColor =  [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:.9];
    [chatBackgroundView addSubview:navBar];
    
    CGRect textFieldRect =
    [self.view.window convertRect:textFieldEdit.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    CGRect viewFrameNav = navBar.frame;
    viewFrameNav.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [navBar setFrame:viewFrameNav];
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    CGRect viewFrameNav = navBar.frame;
    viewFrameNav.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [navBar setFrame:viewFrameNav];
    [UIView commitAnimations];
    
    //[navBar removeFromSuperview];
}

#pragma mark - set up view methods

- (void) navBar {
    
    menuImage = [[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:(NavigationController *)self.navigationController action:@selector(showMenu)];
    
    
    settingsImage = [[UIImage imageNamed:@"cogs.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:(NavigationController *)self.navigationController action:@selector(showSettings)];
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
    [self setupMessageTextView];
    //
}

-(void)chatBackgroundView {
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
}

- (void) setupMessageTextView {
    self.messageTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 528, self.view.frame.size.width, 41)];
    self.messageTextView.alpha = 2.0;
    self.messageTextView.backgroundColor = [UIColor whiteColor];
    [chatBackgroundView addSubview:self.messageTextView];
    //
    //    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, .5)];
    //    line.backgroundColor =  [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
    //    [self.messageTextView addSubview:line];
    
    CGRect frame = CGRectMake(55, 5, 200, self.messageTextView.frame.size.height-10);
    textField = [[UITextField alloc] initWithFrame:frame];
    //textField.center = self.messageTextView.center;
    //textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:17.0];
    textField.placeholder = @"Suchen";
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    // Add a "textFieldDidChange" notification method to the text field control.
    [textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    textField.delegate = self;
    [self.messageTextView addSubview:textField];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(11,4, 32, 32)];
    UIImage *btnImage = [UIImage imageNamed:@"camerax"];
    [cameraButton setImage:btnImage forState:UIControlStateNormal];
    //[textButton setBackgroundImage:[UIImage imageNamed:@"phone_icon20x.png"] forState:UIControlStateNormal];
    //cameraButton.backgroundColor = [UIColor whiteColor];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.messageTextView addSubview:cameraButton];
    
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(sendButtonPressed)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Send" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    //button.titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    [button setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
    
    
    button.frame = CGRectMake(262.0, 4.0, 50.0, 32.0);
    [self.messageTextView addSubview:button];
    
    
    //    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(262, 4, 50, 32)];
    //    //sendButton.backgroundColor = [UIColor yellowColor];
    //
    //    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    //    [sendButton setTitle:@"Send" forState:UIControlStateSelected];
    //    [sendButton setTitle:@"Send" forState:UIControlStateHighlighted];
    //
    //
    //    sendButton.titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    //
    //    [self.messageTextView addSubview:sendButton];
}

- (void)sendButtonPressed {
    if ([textField.text length] != 0) {
        
        PFObject *object = [PFObject objectWithClassName:@"chats"];
        object[@"chapterID"] = self.chapterID;
        object[@"user"] = [PFUser currentUser];
        object[@"text"] = textField.text;
        
        UIImage *tempImage = [attachments objectAtIndex:0];
        NSData *imageData = UIImagePNGRepresentation(tempImage);
        PFFile *newImageFile = [PFFile fileWithName:@"Levis.png" data:imageData];
        [object setObject:newImageFile forKey:@"image"];
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error == nil)
             {
                 [JSQSystemSoundPlayer jsq_playMessageSentSound];
                 [self getMessages];
                 textField.text = @"";
                 [button setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
                 
             }
             else [ProgressHUD showError:@"Network error"];;
         }];
        
    } else {
        [ProgressHUD showError:@"type something..."];
    }
}

- (void)cameraButtonPressed {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take picture/video", @"Choose existing", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    //[actionSheet showInView:self.view];
    
}

# pragma image picker delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //take picture
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes =
            @[(NSString *) kUTTypeImage,
              (NSString *) kUTTypeMovie];
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
            _newMedia = YES;
        }
    } else if (buttonIndex == 1) {
        //choose existing
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            _newMedia = NO;
        }
        
    } else {
        NSLog (@"error with action sheet");
    }
    NSLog(@"Button at index: %ld clicked\nIt's title is '%@'", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}
-(void)imagePickerController:
(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    attachments = [[NSMutableArray alloc] init];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        // Media is an image
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [attachments addObject:image];
        //save image to gallery
        if (_newMedia == YES) {
            
            UIImageWriteToSavedPhotosAlbum(image, self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Media is a video
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSString *videoPath = [url path];
        
        [attachments addObject:videoPath];
        //save video to gallery
        if (_newMedia == YES) {
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath))
            {
                UISaveVideoAtPathToSavedPhotosAlbum(videoPath,
                                                    self,
                                                    @selector(video:finishedSavingWithError:contextInfo:),
                                                    nil);
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)
error contextInfo:(void *)contextInfo
{
    if (error) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)video:(NSString *)video
finishedSavingWithError:(NSError *)
error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save video"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidChange:(UITextField *)textField2 {
    
    if ([textField2.text length] != 0) {
        [button setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
    }
    
}

#pragma mark - load from Parse
-(void)getMessages {
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    UIFont *labelFont = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:14 ];
    
    //style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 5.0f;
    style.headIndent = 5.0f;
    //style.tailIndent = 1.0f;
    
    
    
    upVotedArray = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    
    //fetch messages
    PFQuery *query2 = [PFQuery queryWithClassName:@"chats"];
    [query2 whereKey:@"chapterID" equalTo:self.chapterID];
    [query2 orderByAscending:@"createdAt"];
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        numberOfObjects = objects.count;
        objectCounter = 0;
        
        if (!error) {
            
            NSLog(@"Successfully retrieved %lu messages.", (unsigned long)objects.count);
            
            for (PFObject *object in objects) {
                objectCounter++;
                //NSLog(@"%@", object.objectId);
                //NSLog(@"LOCATION:%@",object[@"location"]);
                MessageObject *messageObj = [[MessageObject alloc] init];
                
                upVotedArray = object[@"upVoted"];
                
                NSString *message = object[@"text"];
                
                NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSParagraphStyleAttributeName: style}];
                [attributedMessage addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, [attributedMessage length])];
                
                BOOL selected = [object[@"selected"] boolValue];
                
                messageObj.selected = selected;
                messageObj.message = attributedMessage;
                messageObj.user = object[@"user"];
                messageObj.timestamp = object[@"createdAt"];
                //messageObj.voteCount = [[object objectForKey:@"voteCount"] integerValue];
                messageObj.voteCount = upVotedArray.count;
                
                for (int i = 0; i < upVotedArray.count; i++) {
                    if( [[PFUser currentUser].objectId isEqualToString:[upVotedArray objectAtIndex:i]] ) {
                        messageObj.selected = YES;
                    }
                }
                
                [messages addObject:messageObj];
                
                if (objectCounter == numberOfObjects) {
                    [self.chatTableView reloadData];
                    NSIndexPath *lastMessageIP = [NSIndexPath indexPathForRow:numberOfObjects-1 inSection:0];
                    [self.chatTableView scrollToRowAtIndexPath:lastMessageIP atScrollPosition:NULL animated:YES];
                }
                
                NSLog(@"upVotedArray:%lu",(unsigned long)upVotedArray.count);
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
        //[self.overlay_ performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
    
    
    
}

#pragma mark - pressedUp method

-(void)pressedUp:(UIButton *)button {
    //NSLog(@"%ld",(long)button.tag);
    NSUInteger index = button.tag;
    __block NSUInteger voteCounterBlock;
    
    if ([button isSelected]) {
        
        [button setSelected:NO];
        //__block NSInteger *voteCounter = [[NSInteger alloc] init];
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"chats"];
        [query whereKey:@"chapterID" equalTo:self.chapterID];
        [query orderByAscending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *messagesBlock, NSError *error) {
            if (!error) {
                // Found UserStats
                
                __block PFObject *message = [messagesBlock objectAtIndex:index];
                
                MessageObject *tempMessageObject = [messages objectAtIndex:button.tag];
                tempMessageObject.selected = false;
                voteCounterBlock = tempMessageObject.voteCount;
                voteCounterBlock--;
                tempMessageObject.voteCount = voteCounterBlock;
                
                [messages replaceObjectAtIndex:button.tag withObject:tempMessageObject];
                
                //[message incrementKey:@"voteCount" byAmount:[NSNumber numberWithInt:-1]];
                NSMutableArray *userID = [[NSMutableArray alloc] init];
                [userID addObject:[PFUser currentUser].objectId];
                [message removeObjectsInArray:userID forKey:@"upVoted"];
                [message saveInBackground];
                //[userStats setObject:newScore forKey:@"latestScore"];
                NSLog(@"Successfully retrieved %lu scores. %@", (unsigned long)messagesBlock.count, message);
                
                [self.chatTableView reloadData];
                
                // Save
                //[userStats saveInBackground];
            } else {
                // Did not find any UserStats for the current user
                NSLog(@"Error: %@", error);
            }
        }];
        
        
        
    } else {
        
        [button setSelected:YES];
        PFQuery *query = [PFQuery queryWithClassName:@"chats"];
        [query whereKey:@"chapterID" equalTo:self.chapterID];
        [query orderByAscending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *messagesBlock, NSError *error) {
            if (!error) {
                // Found UserStats
                
                __block PFObject *message = [messagesBlock objectAtIndex:index];
                
                MessageObject *tempMessageObject = [messages objectAtIndex:button.tag];
                tempMessageObject.selected = true;
                voteCounterBlock = tempMessageObject.voteCount;
                voteCounterBlock++;
                tempMessageObject.voteCount = voteCounterBlock;
                
                [messages replaceObjectAtIndex:button.tag withObject:tempMessageObject];
                //[message incrementKey:@"voteCount" byAmount:[NSNumber numberWithInt:1]];
                
                NSMutableArray *userID = [[NSMutableArray alloc] init];
                [userID addObject:[PFUser currentUser].objectId];
                [message addObjectsFromArray:userID forKey:@"upVoted"];
                [message saveInBackground];
                
                NSLog(@"Successfully retrieved %lu scores. %@", (unsigned long)messagesBlock.count, message);
                
                [self.chatTableView reloadData];
                
                //[userStats setObject:newScore forKey:@"latestScore"];
                
                // Save
                //[userStats saveInBackground];
            } else {
                // Did not find any UserStats for the current user
                NSLog(@"Error: %@", error);
            }
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Methods

- (void)keyboardWillAppear:(NSNotification *)notification
{
    
    
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    [self.chatTableView setContentInset:contentInsets];
    [self.chatTableView setScrollIndicatorInsets:contentInsets];
    
    CGRect messageFrame = self.messageTextView.frame;
    messageFrame.origin.y -= keyboardSize.height;
    [self.messageTextView setFrame:messageFrame];
}

- (void)keyboardWillDisappear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [self.chatTableView setContentInset:UIEdgeInsetsZero];
    [UIView commitAnimations];
    [self.chatTableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
    CGRect messageFrame = self.messageTextView.frame;
    messageFrame.origin.y += keyboardSize.height;
    [self.messageTextView setFrame:messageFrame];
}


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
    return numberOfObjects;
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
        
        //cell.textLabel.text = [messageArray objectAtIndex:indexPath.row];
        //cell.textLabel.frame = CGRectMake(20,20,200,800);
        cell.upVoteButton.tag = indexPath.row;
        [cell.upVoteButton addTarget:self action:@selector(pressedUp:)  forControlEvents:UIControlEventTouchUpInside];
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
        [cell.voteCount setText:[NSString stringWithFormat:@"%lu",(unsigned long)tempMessageObject.voteCount]];
        //cell.voteCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)tempMessageObject.voteCount];
        if (tempMessageObject.selected) {
            [cell.upVoteButton setSelected:YES];
        }
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
        //NSLog(@"%f",heightOfcell);
        
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
