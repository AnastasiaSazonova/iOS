//
//  EditFriendsViewController.m
//  Ribbit
//
//  Created by Anastasia on 3/18/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "EditFriendsViewController.h"


const NSString * friendsRelation = @"friendsRelation";
const NSString * username = @"username";

@implementation EditFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery * query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"error %@, %@", error, [error userInfo]);
         }
         else
         {
             self.allUsers = objects;
             [self.tableView reloadData];
         }
     }
     ];
    self.currentUser = [PFUser currentUser];
    
}


#pragma mark -methods
-(BOOL)isFriend:(PFUser *)user
{
    for (PFUser * friend in self.friends)
    {
        if ([friend.objectId isEqualToString:user.objectId])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFUser * user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    if ([self isFriend:user])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    PFRelation * friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    PFUser * user = [self.allUsers objectAtIndex:indexPath.row];
    if ([self isFriend:user])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        for (PFUser * friend in self.friends)
        {
            if ([friend.objectId isEqual:user.objectId])
            {
                [self.friends removeObject:friend];
                break;
            }
        }
        PFRelation * friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
        [friendsRelation removeObject:user];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.friends addObject:user];
        [friendsRelation addObject:user];
    }

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             NSLog(@"error: %@ %@", error, [error userInfo]);
         }
     }];
}

@end








