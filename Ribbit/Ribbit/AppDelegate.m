//
//  AppDelegate.m
//  Ribbit
//
//  Created by Anastasia on 3/16/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [NSThread sleepForTimeInterval:1.5];
    [Parse setApplicationId:@"fG8MHmf6U18dqcbLdfc35tnnc6vxSTkeFhpx94ss"
                  clientKey:@"OugdzOpxyOAZbO6Rlr7Q90lqPMKvF2DMZPxbbnRC"];
    return YES;
}
@end
