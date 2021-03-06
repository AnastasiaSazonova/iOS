//
//  EditFriendsViewController.h
//  Ribbit
//
//  Created by Anastasia on 3/18/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsViewController : UITableViewController

extern NSString * friendsRelation;
extern NSString * username;

@property(nonatomic, strong)NSArray * allUsers;
@property(nonatomic, strong)PFUser * currentUser;
@property(nonatomic, strong)NSMutableArray * friends;

-(BOOL)isFriend:(PFUser*)user;
@end
