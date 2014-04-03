//
//  CameraViewController.m
//  Ribbit
//
//  Created by Anastasia on 3/19/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recipients = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self updateData];
    [self updateView];
}

- (IBAction)touchCancelButton:(UIBarButtonItem *)sender
{
    [self resetProperties];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)touchSendButton:(UIBarButtonItem *)sender
{
    if (self.image == nil && [self.videoFilePath length] == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Try again!" message:@"Please, try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    else
    {
        if ([self.recipients count] == 0)
        {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Error occured!" message:@"Please, choose recipients!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            [self uploadMessage];
            [self.tabBarController setSelectedIndex:0];
        }
    }
}

-(void)uploadMessage
{
    NSData * fileData;
    NSString * fileName;
    NSString * fileType;
    if (self.image != nil)
    {
        UIImage * newImage = [self resizeImage:self.image toWidth:320.f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    }
    else
    {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    PFFile * file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Error occured!" message:@"Please, try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            PFObject * message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientsIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                if (error)
                {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Error occured!" message:@"Please, try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }
                else
                {
                    [self resetProperties];
                }
            }];
        }
    }];
}

-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

-(void)resetProperties
{
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

-(void)updateData
{
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery * query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"error %@ %@", error, [error userInfo]);
         }
         else
         {
             self.friends = objects;
             [self.tableView reloadData];
         }
     }];
    
}

-(void)updateView
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.videoMaximumDuration = 10;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFUser * user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self.recipients containsObject:user.objectId])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friends count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser * user = [self.friends objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath))
            {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}

@end
