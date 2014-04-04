//
//  FriendsViewController.m
//  Ribbit
//
//  Created by Anastasia on 3/18/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsViewController.h"

NSString * showEditFriends = @"showEditFriends";

@implementation FriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateData];
}

-(void)updateData
{
    self.friendsRelation = [[PFUser currentUser] objectForKey:friendsRelation];
    PFQuery * query = [self.friendsRelation query];
    [query orderByAscending:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"error %@ %@", error, [error userInfo]);
         }
         else
         {
             self.friends = objects;
             [self.tableView reloadData];
         }
     }];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:showEditFriends])
    {
        EditFriendsViewController * viewController = (EditFriendsViewController *)segue.destinationViewController;
        viewController.friends = [NSMutableArray arrayWithArray:self.friends];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFUser * user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    return cell;
}

@end
