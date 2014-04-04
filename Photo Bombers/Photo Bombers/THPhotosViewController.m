//
//  THPhotosViewController.m
//  Photo Bombers
//
//  Created by Anastasia on 3/25/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "THPhotosViewController.h"
#import "THPhotoCell.h"
#import "THDetailViewController.h"
#import "THPresentDetailTransition.h"
#import "THDismissDetailTransition.h"
#import <SimpleAuth/SimpleAuth.h>

NSString * accessTokenString = @"accessToken";
NSString * credentials = @"credentials";
NSString * token = @"token";
NSString * photo = @"photo";
NSString * data = @"data";

@interface THPhotosViewController ()<UIViewControllerTransitioningDelegate>

@property(nonatomic, strong)NSString * accessToken;
@property(nonatomic, strong)NSArray * photos;

@end

@implementation THPhotosViewController

-(instancetype)init
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    return self = [super initWithCollectionViewLayout:layout];
}

-(void)viewDidLoad
{
    [self.collectionView registerClass:[THPhotoCell class] forCellWithReuseIdentifier:photo];
    self.title = @"Photo Bombers";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:accessTokenString];
    if ([self.accessToken length] == 0)
    {
        [SimpleAuth authorize:@"instagram" options:@{@"scope" : @[@"likes"]} completion:^(NSDictionary * responseObject, NSError * error)
        {
            self.accessToken = responseObject[credentials][token];
            [userDefaults setObject:self.accessToken forKey:accessTokenString];
            [userDefaults synchronize];
            [self refresh];
        }];
    }
    else
    {
        [self refresh];
    }
}

-(void)refresh
{
    NSLog(@"Signed in!");
    NSURLSession * session = [NSURLSession sharedSession];
    NSString * urlString = [[NSString alloc]initWithFormat:@"https://api.instagram.com/v1/tags/photobomb/media/recent?access_token=%@", self.accessToken];
    NSURL * url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
                                       {
                                           NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
                                           NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
                                           self.photos = [dictionary valueForKey:data];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self.collectionView reloadData];
                                           });
                                       }];
    [task resume];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    THPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:photo forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * photo = self.photos[indexPath.row];
    THDetailViewController * detailVC = [[THDetailViewController alloc] init];
    detailVC.photo = photo;
    detailVC.modalPresentationStyle = UIModalPresentationCustom;
    detailVC.transitioningDelegate = self;
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[THPresentDetailTransition alloc] init];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[THDismissDetailTransition alloc]init];
}

@end




