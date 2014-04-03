//
//  LoginViewController.m
//  Ribbit
//
//  Created by Anastasia on 3/17/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setHidden:YES];
    if ([UIScreen mainScreen].bounds.size.height == 568)
    {
        self.imageView.image = [UIImage imageNamed:@"loginBackground-568h"];
    }
}

- (IBAction)login:(UIButton *)sender
{
    NSString * userName = [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * password = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([userName length] == 0 || [password length] == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you entered right data!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error)
        {
            if (error)
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                     message:[error.userInfo objectForKey:@"error"]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    ];
    }
    
}

@end
