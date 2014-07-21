//
//  THNewEntryViewController.m
//  Diary
//
//  Created by Anastasia on 7/13/14.
//  Copyright (c) 2014 Anastasia Sazonova. All rights reserved.
//

#import "THEntryViewController.h"
#import "CoreDataStack.h"
#import "THDiaryEntity.h"
#import <CoreLocation/CoreLocation.h>

static const int limit = 10;

@interface THEntryViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate>
{
    NSUInteger charactersCounter;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, assign) enum THDiaryEntryMood mood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;// strong because THEntryViewController doesn't own this view (scene does).
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic, strong) UIImage *pickedImage;

@end

@implementation THEntryViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.textView becomeFirstResponder];//puts textview in focus
    self.textView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate * date;
    if (self.entry)
    {
        self.textView.text = self.entry.body;
        self.mood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    }
    else
    {
        self.mood = THDiaryEntryMoodGood;
        date = [NSDate date];
    }
    [self loadLocation];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, dd MMMM yyyy"];
    self.dateLabel.text = [formatter stringFromDate:date];
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2.0f;
    self.textView.inputAccessoryView = self.accessoryView;
    
    if ([self.textView.text length] > 0)
    {
        charactersCounter = [self.textView.text length];
    }
    else
    {
        charactersCounter = limit;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu", limit - [self.textView.text length]];
}

-(void)loadLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000; //meters
    
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemerk = [placemarks firstObject];
        self.location = placemerk.name;
    }];
}

-(void)setMood:(enum THDiaryEntryMood)mood
{
    _mood = mood;
    
    self.goodButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.badButton.alpha = 0.5f;
    
    switch (mood)
    {
        case THDiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
        case THDiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
        case THDiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
        default:
            break;
    }
}

- (IBAction)badWasPressed:(UIButton *)sender
{
    self.mood = THDiaryEntryMoodBad;
}

- (IBAction)averageWasPressed:(UIButton *)sender
{
    self.mood = THDiaryEntryMoodAverage;
}

- (IBAction)goodWasPressed:(UIButton *)sender
{
    self.mood = THDiaryEntryMoodGood;
}

-(void)insertDiaryEntity
{
    CoreDataStack * coreDataStack = [CoreDataStack defaultStack];
    THDiaryEntity * diaryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"THDiaryEntity" inManagedObjectContext:coreDataStack.managedObjectContext];
    diaryEntity.body = self.textView.text;
    diaryEntity.date = [[NSDate date] timeIntervalSince1970];
    diaryEntity.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    diaryEntity.location = self.location;
    [coreDataStack saveContext];
}

- (IBAction)imageButtonWasPressed:(UIButton *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self promptFromSource];
    }
    else
    {
        [self promptForPhotoRoll];
    }
}

- (void)promptFromSource
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Camera", @"Photo Roll", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex == actionSheet.firstOtherButtonIndex)
        {
            [self promptForCamera];
        }
        else
        {
            [self promptForPhotoRoll];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text length] + 1 == limit)
    {
        
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu", limit - ([textView.text length] + 1)];
    return !([textView.text length] >= limit - 1 && [text length] >= range.length);
}

- (void)promptForCamera
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)promptForPhotoRoll
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

-(void)setPickedImage:(UIImage *)pickedImage
{
    _pickedImage = pickedImage;
    if (!pickedImage)
    {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    }
    else
    {
        [self.imageButton setImage:self.pickedImage forState:UIControlStateNormal];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self dismissSelf];
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    if (self.entry)
    {
        [self updateDiaryEntry];
    }
    else
    {
        [self insertDiaryEntity];
    }
    [self dismissSelf];
}

-(void)updateDiaryEntry
{
    self.entry.body = self.textView.text;
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    [[CoreDataStack defaultStack] saveContext];
}

-(void)dismissSelf
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
