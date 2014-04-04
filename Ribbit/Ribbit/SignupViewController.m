//
//  SignupViewController.m
//  Ribbit
//
//  Created by Anastasia on 3/17/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIScreen mainScreen].bounds.size.height == 568)
    {
        self.imageView.image = [UIImage imageNamed:@"loginBackground-568h"];
    }
}

- (IBAction)dismiss:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUp:(UIButton *)sender
{
    NSString * userName = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([userName length] == 0 || [password length] == 0 || [email length] == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you entered right data!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        PFUser * newUser = [PFUser user];
        newUser.username = userName;
        newUser.password = password;
        newUser.email = email;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
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
        }];
        
    }
    
}

@end
