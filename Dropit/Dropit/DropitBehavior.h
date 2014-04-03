//
//  DropitBehavior.h
//  Dropit
//
//  Created by Anastasia on 3/30/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

-(void)addItem:(id<UIDynamicItem>)item;
-(void)removeItem:(id<UIDynamicItem>)item;

@end
