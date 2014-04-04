//
//  InboxTableViewController.m
//  Ribbit
//
//  Created by Anastasia on 3/17/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "InboxTableViewController.h"
#import "ImageViewController.h"

NSString * recipientsIds = @"recipientsIds";
NSString * messages = @"Messages";
NSString * showImage = @"showImage";
NSString * showLogin = @"showLogin";



@implementation InboxTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.moviePlayer = [[MPMoviePlayerController alloc] init];

    PFUser * currentUser = [PFUser currentUser];
    if (currentUser)
    {
        NSLog(@"current User %@", currentUser.username);
    }
    else
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];
    PFQuery * query = [PFQuery queryWithClassName:messages];
    [query whereKey:@"recipientsIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            NSLog(@" %@, %@", error, [error userInfo]);
        }
        else
        {
            self.messages = objects;
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)logOut:(UIBarButtonItem *)sender
{
    [PFUser logOut];
    [self performSegueWithIdentifier:showLogin sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject * message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    NSString * fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"])
    {
        UIImage * _image = [UIImage imageNamed:@"icon_image"];
        cell.imageView.image = _image;
    }
    else
    {
        UIImage * _image = [UIImage imageNamed:@"icon_video"];
        cell.imageView.image = _image;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString * fileType = [self.selectedMessage objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"])
    {
        [self performSegueWithIdentifier:showImage sender:self];
    }
    else
    {
        PFFile * videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL * fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        [self.moviePlayer prepareToPlay];
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:recipientsIds]];
    if ([array count] == 1)
    {
        [self.selectedMessage deleteInBackground];
    }
    else
    {
        [array removeObject:[[PFUser currentUser]objectId]];
        [self.selectedMessage setObject:array forKey:recipientsIds];
        [self.selectedMessage saveInBackground];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:showLogin])
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:showImage])
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController * imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
    }
}
@end
