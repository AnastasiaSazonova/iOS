//
//  THEntryCell.h
//  Diary
//
//  Created by Anastasia on 7/14/14.
//  Copyright (c) 2014 Anastasia Sazonova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THDiaryEntity;

@interface THEntryCell : UITableViewCell

+(CGFloat)heightForEntry:(THDiaryEntity *)entry;

-(void)configureCellForEntry:(THDiaryEntity *)entry;

@end
