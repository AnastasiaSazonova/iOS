//
//  Card.m
//  Matchismo
//
//  Created by Anastasia on 1/24/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "Card.h"

@implementation Card

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card * card in otherCards)
    {
        if([card.contents isEqualToString:self.contents])
        {
            score += 1;
        }
    }
    return score;
}

@end
