//
//  ImageViewController.m
//  Ribbit
//
//  Created by Anastasia on 3/20/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "ImageViewController.h"

NSString * senderName = @"senderName";
NSString * file = @"file";

@interface ImageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFFile * imageFile = [self.message objectForKey:file];
    NSURL * imageUrl = [[NSURL alloc]initWithString:imageFile.url];
    NSData * imageData = [NSData dataWithContentsOfURL:imageUrl];
    self.imageView.image = [UIImage imageWithData:imageData];
    NSString * title = [self.message objectForKey:senderName];
    self.navigationItem.title = title;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    if ([self respondsToSelector:@selector(timeOut)])
    {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    }
}

-(void)timeOut
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
