//
//  AppDelegate.m
//  Photo Bombers
//
//  Created by Anastasia on 3/25/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "AppDelegate.h"
#import "THPhotosViewController.h"
#import <SimpleAuth/SimpleAuth.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SimpleAuth.configuration[@"instagram"] = @{
                                               @"client_id" : @"d8f9dc9919134fdd9e46cf7ac743fd79",
                                               SimpleAuthRedirectURIKey : @"photobombers://auth/instagram"
                                               };
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    THPhotosViewController * photosViewController = [[THPhotosViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:photosViewController];
    UINavigationBar * navigationBar = navigationController.navigationBar;
    navigationBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:122.0/255.0 blue:87.0/255.0 alpha:1.0];
    navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
