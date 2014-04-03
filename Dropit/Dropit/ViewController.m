//
//  ViewController.m
//  Dropit
//
//  Created by Anastasia on 3/30/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehavior.h"
#import "BezierPathView.h"
#import <SAMGradientView/SAMGradientView.h>

@interface ViewController ()<UIDynamicAnimatorDelegate>

@property(weak, nonatomic) IBOutlet BezierPathView * gameView;
@property(strong, nonatomic)UIDynamicAnimator * animator;
@property(strong, nonatomic)DropitBehavior * dropitBehavior;
@property(strong, nonatomic)UIAttachmentBehavior * attachment;
@property(strong, nonatomic)UIView * droppingView;

@end

@implementation ViewController

static const CGSize DROP_SIZE = {40, 40};

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Tap the screen to start!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

-(UIDynamicAnimator *)animator
{
    if (!_animator)
    {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];//!!!
        _animator.delegate = self;
    }
    return _animator;
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}

-(BOOL)removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for (CGFloat y = self.gameView.bounds.size.height - DROP_SIZE.height / 2; y > 0; y -= DROP_SIZE.height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width / 2; x <= self.gameView.bounds.size.width - DROP_SIZE.width / 2; x += DROP_SIZE.width)
        {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView)
            {
                [dropsFound addObject:hitView];
            }
            else
            {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) break;
        if (rowIsComplete)
        {
            [dropsToRemove addObjectsFromArray:dropsFound];
        }
    }
    
    if ([dropsToRemove count])
    {
        for (UIView *drop in dropsToRemove)
        {
            [self.dropitBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
        return YES;
    }
    
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove
{
    [UIView animateWithDuration:1.0 animations:
     ^{
        for (UIView *drop in dropsToRemove)
        {
            int x = (arc4random() % (int)(self.gameView.bounds.size.width * 5)) - (int)self.gameView.bounds.size.width * 2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, -y);
        }
    }
                     completion:^(BOOL finished)
                     {
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

-(DropitBehavior *)dropitBehavior
{
    if (!_dropitBehavior)
    {
        _dropitBehavior = [[DropitBehavior alloc] init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self attachDroppingViewToPoint:gesturePoint];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        self.attachment.anchorPoint = gesturePoint;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}

-(void)attachDroppingViewToPoint:(CGPoint)anchorPoint
{
    if (self.droppingView)
    {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        UIView * droppingView = self.droppingView;
        __weak ViewController * weakSelf = self;
        self.attachment.action =
        ^{
            UIBezierPath * path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.gameView.path = path;
        };
        self.droppingView = nil;
        [self.animator addBehavior:self.attachment];
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [self drop];
}

-(void)drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.gameView.bounds.size.width)/DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    SAMGradientView * gradient = [[SAMGradientView alloc] initWithFrame:frame];
    gradient.gradientColors = @[[self randomColor], [self randomColor]];
    
    //UIView * dropView = [[UIView alloc] initWithFrame:frame];
    //dropView.backgroundColor = [self randomColor];
    self.droppingView = gradient;
    [self.gameView addSubview:gradient];
    [self.dropitBehavior addItem:gradient];
}

-(UIColor *)randomColor
{
    switch (arc4random()%5)
    {
        case 1:
            return [UIColor orangeColor];
        case 2:
            return [UIColor redColor];
        case 3:
            return [UIColor greenColor];
        case 4:
            return [UIColor yellowColor];
        case 5:
            return [UIColor whiteColor];
    }
    return [UIColor redColor];
}

@end
