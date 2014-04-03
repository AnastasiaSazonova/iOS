//
//  BezierPathView.m
//  Dropit
//
//  Created by Anastasia on 3/31/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

-(void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [self.path stroke];
}

@end
