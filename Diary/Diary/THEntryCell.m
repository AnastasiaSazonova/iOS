//
//  THEntryCell.m
//  Diary
//
//  Created by Anastasia on 7/14/14.
//  Copyright (c) 2014 Anastasia Sazonova. All rights reserved.
//

#import "THEntryCell.h"
#import "THDiaryEntity.h"
#import "QuartzCore/QuartzCore.h"

@interface THEntryCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation THEntryCell

+(CGFloat)heightForEntry:(THDiaryEntity *)entry
{
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 85.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont * font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(202, CGFLOAT_MAX)
                                                  options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin)
                                               attributes:@{NSFontAttributeName: font}
                                                  context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}

-(void)configureCellForEntry:(THDiaryEntity *)entry
{
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, d MMMM"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if (entry.location.length > 0)
    {
        self.locationLabel.text = entry.location;
    }
    else
    {
        self.locationLabel.text = @"No location";
    }
    
    if (entry.imageData)
    {
        self.mainImageView.image = [UIImage imageWithData:entry.imageData];
    }
    else
    {
        self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
    }
    
    if (entry.mood == THDiaryEntryMoodGood)
    {
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    }
    else if(entry.mood == THDiaryEntryMoodAverage)
    {
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    }
    else if(entry.mood == THDiaryEntryMoodBad)
    {
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }
    self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame)/2.0f;
}

@end
