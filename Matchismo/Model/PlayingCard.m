//
//  PlayingCard.m
//  Matchismo
//
//  Created by Anastasia on 1/24/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit; //because we provide BOTH setter and getter

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count])
    {
        for (int i = 0; i < [otherCards count]; i++)
        {
            id card = [otherCards objectAtIndex:i];
            if ([card isKindOfClass:[PlayingCard class]])
            {
                PlayingCard * otherCard = (PlayingCard *)card;
                if (otherCard.rank == self.rank)
                {
                    score += 4;
                }
                else if([otherCard.suit isEqualToString:self.suit])
                {
                    score += 1;
                }
                
            }

        }
    }
    if ([otherCards count] > 1)
    {
        score += [[otherCards firstObject] match:[otherCards subarrayWithRange:NSMakeRange(1, [otherCards count] - 1)]];
    }
    return score;
}

-(NSString *)contents
{
    NSArray * rankStrings = @[@"?", @"2", @"3", @"4",@"5", @"6", @"7", @"8", @"9",@"10", @"J", @"Q", @"K", @"A"];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
    //return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

+(NSArray *)validSuits
{
    return @[@"♥", @"♠", @"♣", @"♦"];
}

-(void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

-(NSString *)suit
{
    return _suit ? _suit : @"?";
}

+(NSArray *)rankStrings
{
    return @[@"?", @"2", @"3", @"4",@"5", @"6", @"7", @"8", @"9",@"10", @"J", @"Q", @"K", @"A"];
}

+(NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

-(void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

@end
