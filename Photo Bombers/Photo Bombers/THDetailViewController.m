//
//  THDetailViewController.m
//  Photo Bombers
//
//  Created by Anastasia on 3/27/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "THDetailViewController.h"
#import "THPhotoController.h"
#import "THMetaView.h"

@interface THDetailViewController ()

@property(nonatomic, strong)UIImageView * imageView;
@property(nonatomic, strong)UIDynamicAnimator * animator;
@property(nonatomic, strong)THMetaView * metaView;

@end

@implementation THDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,-320.0, 320.0f, 320.0f)];
    [self.view addSubview:self.imageView];
    
    self.metaView = [[THMetaView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 390.0)];
    self.metaView.alpha = 0.0;
    self.metaView.photo = self.photo;
    [self.view addSubview:self.metaView];
    
    [THPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
}

-(void)viewDidAppear:(BOOL)animated
{
    CGPoint point = CGPointMake(self.view.center.x, self.view.center.y - 20);
    UISnapBehavior * snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint: point];
    [self.animator addBehavior:snap];

    CGPoint metaViewCenter = CGPointMake(point.x, point.y - 0);
    self.metaView.center = metaViewCenter;
    [UIView animateWithDuration:0.5 delay:0.7 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:kNilOptions animations:^{self.metaView.alpha = 1.0;} completion:nil];
}

-(void)close
{
    [self.animator removeAllBehaviors];
    UISnapBehavior * snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds),CGRectGetMaxY(self.view.bounds) + 180.0f)];
    [self.animator addBehavior:snap];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
