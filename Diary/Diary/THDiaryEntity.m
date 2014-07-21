//
//  THDiaryEntity.m
//  Diary
//
//  Created by Anastasia on 7/13/14.
//  Copyright (c) 2014 Anastasia Sazonova. All rights reserved.
//

#import "THDiaryEntity.h"


@implementation THDiaryEntity

@synthesize sectionName;
@dynamic date;
@dynamic body;
@dynamic imageData;
@dynamic mood;
@dynamic location;

-(NSString *)sectionName
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
