//
//  ImageViewController.h
//  Ribbit
//
//  Created by Anastasia on 3/20/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

extern NSString * file;

@property(nonatomic, strong)PFObject * message;

@end
