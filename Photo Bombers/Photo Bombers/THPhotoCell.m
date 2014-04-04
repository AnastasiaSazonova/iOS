//
//  THPhotoCell.m
//  Photo Bombers
//
//  Created by Anastasia on 3/25/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "THPhotoCell.h"
#import "THPhotoController.h"

NSString * url = @"link";
NSString * accessTokenStr = @"accessToken";

@implementation THPhotoCell

-(void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    [THPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image)
     {
        self.imageView.image = image;
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView= [[UIImageView alloc] init];
       // self.imageView.image = [UIImage imageNamed:@"Treehouse"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

-(void)like
{
    NSLog(@"Link: %@", self.photo[url]);
    NSURLSession * session = [NSURLSession sharedSession];
    NSString * accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:accessTokenStr];
    NSString * urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
    NSURL * url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:
                                       ^(NSData *data, NSURLResponse *response, NSError *error)
                                       {
                                           dispatch_async(dispatch_get_main_queue(),
                                           ^{
                                               [self showLikeCompletion];
                                            });
                                       }];
    [dataTask resume];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

-(void)showLikeCompletion
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Liked!"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    double delayInSeconds = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

@end
