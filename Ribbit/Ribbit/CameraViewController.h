//
//  CameraViewController.h
//  Ribbit
//
//  Created by Anastasia on 3/19/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong)UIImagePickerController * imagePicker;
@property(nonatomic, strong)UIImage * image;
@property(nonatomic, strong)NSString * videoFilePath;
@property(nonatomic, strong)PFRelation * friendsRelation;
@property(nonatomic, strong)NSArray * friends;
@property(nonatomic, strong)NSMutableArray * recipients;

@end
