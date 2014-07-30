//
//  ChatTableViewController.m
//  ChillFratGreek
//
//  Created by Hunter Houston on 7/24/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatTableViewCell.h"

@interface ChatTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat height;
    NSString *text;
}

@end

@implementation ChatTableViewController

- (id) init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tableViewFrame = CGRectMake(0, 310, self.view.frame.size.width,200);
    //[self setUpTableView];
}

-(void)setUpTableView {
    //CGRect tableViewFrame = CGRectMake(0, -height, 0, height);
    //self.chatTableview = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.chatTableview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.chatTableview.dataSource = self;
    self.chatTableview.delegate = self;
    self.chatTableview.alpha = .70;
    //self.overlay_.backgroundColor = [UIColor clearColor];
    //self.overlay_.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(38/255.0) blue:(205/255.0) alpha:.9];
    //self.overlay_.backgroundColor = HEXCOLOR(663399);
    [self.view addSubview:self.chatTableview];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
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
    
    cell.textLabel.text = text;
    [cell.textLabel sizeToFit];
    height = CGRectGetHeight(cell.textLabel.bounds);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 143;
    }
    if (indexPath.row == 1) {
        return height;
    }
    
    return height;
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
