//
//  DropitBehavior.m
//  Dropit
//
//  Created by Anastasia on 3/30/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "DropitBehavior.h"

@interface DropitBehavior()

@property(strong, nonatomic)UIGravityBehavior * gravity;
@property(strong, nonatomic)UICollisionBehavior * collider;
@property(strong, nonatomic)UIDynamicItemBehavior * animationsOptions;

@end

@implementation DropitBehavior

-(instancetype)init
{
    if (self = [super init])
    {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collider];
        [self addChildBehavior:self.animationsOptions];
    }
    return self;
}

-(UIGravityBehavior *)gravity
{
    if (!_gravity)
    {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.9f;
    }
    return _gravity;
}

-(UICollisionBehavior *)collider
{
    if (!_collider)
    {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}

-(UIDynamicItemBehavior *)animationsOptions
{
    if (!_animationsOptions)
    {
        _animationsOptions = [[UIDynamicItemBehavior alloc] init];
        _animationsOptions.allowsRotation = NO;
    }
    return _animationsOptions;
}

-(void)addItem:(id<UIDynamicItem>)item
{
    [self.gravity addItem:item];
    [self.collider addItem:item];
    [self.animationsOptions addItem:item];
}

-(void)removeItem:(id<UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
    [self.animationsOptions removeItem:item];
}

@end
