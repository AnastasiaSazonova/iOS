//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Anastasia on 1/24/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "MatchismoViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

@interface MatchismoViewController ()


@property (strong, nonatomic) CardMatchingGame * game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (strong, nonatomic) NSMutableArray *flipHistory;
@property (weak, nonatomic) IBOutlet UISlider *flipHistorySlider;


@end

@implementation MatchismoViewController

#pragma mark -Instantiations
-(CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
        _modeSelector.userInteractionEnabled = NO;
    }
    return _game;
}

-(Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSMutableArray *)flipHistory
{
    if (!_flipHistory)
    {
        _flipHistory = [[NSMutableArray alloc]init];
    }
    return _flipHistory;
}

#pragma mark -IBActions
- (IBAction)touchCardButton:(UIButton*)sender
{
    int chosenButtonIndex = (int)[self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)resetGame:(UIButton*)sender
{
    self.game = nil;
    self.flipHistory = nil;
    [self.flipHistorySlider setValue: 0.0];
    [self updateUI];
    _flipHistorySlider.userInteractionEnabled = NO;
    _modeSelector.userInteractionEnabled = YES;
    
}

- (IBAction)changeModeSelector:(UISegmentedControl *)sender
{
    self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}

- (IBAction)changeSlider:(UISlider *)sender
{
    int sliderValue;
    sliderValue = (int)lroundf(self.flipHistorySlider.value);
    [self.flipHistorySlider setValue:sliderValue animated:NO];
    if ([self.flipHistory count])
    {
        self.flipDescription.alpha = (sliderValue + 1 < [self.flipHistory count]) ? 0.6 : 1.0;
        self.flipDescription.text = [self.flipHistory objectAtIndex:sliderValue];
    }
}

#pragma mark -updateUI
-(void)updateUI
{
    for(UIButton * cardButton in self.cardButtons)
    {
        int cardButtonIndex = (int)[self.cardButtons indexOfObject:cardButton];
        Card * card =[self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    }
    
    if (self.game)
    {
        NSString * description = @"";
        
        if ([self.game.lastChosenCards count])
        {
            NSMutableArray *cardContents = [NSMutableArray array];
            for (Card *card in self.game.lastChosenCards)
            {
                [cardContents addObject:card.contents];
            }
            description = [cardContents componentsJoinedByString:@" "];
        }
        
        if (self.game.lastScore > 0)
        {
            description = [NSString stringWithFormat:@"Matched %@ for %d points.\n", description, (int)self.game.lastScore];
        }
        else if (self.game.lastScore < 0)
        {
            description = [NSString stringWithFormat:@"%@ don’t match! %d point penalty!\n", description, -(int)self.game.lastScore];
        }
        
        self.flipDescription.text = description;
        self.flipDescription.alpha = 1;
        
        if (![self.description isEqualToString:@""] && ![[self.flipHistory lastObject] isEqualToString:description])
        {
            [self.flipHistory addObject:description];
            [self setSliderRange];
        }
    }
     _flipHistorySlider.userInteractionEnabled = YES;
}

-(void)setSliderRange
{
    int maxValue = (int)[self.flipHistory count] - 1;
    self.flipHistorySlider.maximumValue = maxValue;
    [self.flipHistorySlider setValue:maxValue animated:YES];
}

-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed: card.isChosen ? @"cardFront" : @"cardBack"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass: [HistoryViewController class]])
    {
        [segue.destinationViewController setArrayOfDescriptions:self.flipHistory];
    }
}

@end
