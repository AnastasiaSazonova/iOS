//
//  Item.h
//  RSSParser
//
//  Created by Anastasia on 3/21/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property(nonatomic, strong)NSString * name;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * description;
@property(nonatomic, strong)NSString * pubDate;
@property(nonatomic, strong)NSURL * link;

@end
