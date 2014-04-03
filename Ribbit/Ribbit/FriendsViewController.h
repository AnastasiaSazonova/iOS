//
//  FriendsViewController.h
//  Ribbit
//
//  Created by Anastasia on 3/18/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController

@property(nonatomic, strong)PFRelation * friendsRelation;
@property(nonatomic, strong)NSArray * friends;

@end
