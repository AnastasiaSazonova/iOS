//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Anastasia on 4/2/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.historyTextView.userInteractionEnabled = YES;
    //self.tabBarItem.
    for (NSString * description in self.arrayOfDescriptions)
    {
        self.historyTextView.text = [self.historyTextView.text stringByAppendingString:description];
        [self.historyTextView sizeToFit];
    }
}

@end
