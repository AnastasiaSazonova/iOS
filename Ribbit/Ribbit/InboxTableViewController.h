//
//  InboxTableViewController.h
//  Ribbit
//
//  Created by Anastasia on 3/17/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxTableViewController : UITableViewController

@property(nonatomic, strong)NSArray * messages;
@property(nonatomic, strong)PFObject * selectedMessage;
@property(nonatomic, strong)MPMoviePlayerController * moviePlayer;

@end
