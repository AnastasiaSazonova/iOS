//
//  THDismissDetailTransition.m
//  Photo Bombers
//
//  Created by Anastasia on 3/27/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "THDismissDetailTransition.h"

@implementation THDismissDetailTransition

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [UIView animateWithDuration:0.3
                     animations:^{
                         detail.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished)
     {
         [detail.view removeFromSuperview];
         [transitionContext completeTransition:YES];
     }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}



@end
