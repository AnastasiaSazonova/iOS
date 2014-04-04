//
//  THPhotoController.m
//  Photo Bombers
//
//  Created by Anastasia on 3/27/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "THPhotoController.h"
#import <SAMCache/SAMCache.h>

@implementation THPhotoController

+(void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void (^)(UIImage *))completion
{
    if (photo == nil || size == nil || completion == nil)
    {
        return;
    }
    NSString * key = [[NSString alloc] initWithFormat:@"%@-%@", photo[@"id"], size];
    UIImage * image = [[SAMCache sharedCache] imageForKey:key];
    if (image)
    {
        completion(image);
        return;
    }
    NSURL * url = [[NSURL alloc] initWithString:photo[@"images"][size][@"url"]];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
                                               {
                                                   NSData * data = [[NSData alloc]initWithContentsOfURL:location];
                                                   UIImage * image = [[UIImage alloc]initWithData:data];
                                                   [[SAMCache sharedCache] setImage:image forKey:key];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       completion(image);
                                                   });
                                               }];
    [downloadTask resume];

}

@end
