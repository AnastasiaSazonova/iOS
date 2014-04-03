//
//  XmlElement.h
//  RSSParser
//
//  Created by Anastasia on 3/21/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlElement : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, weak) XmlElement * parent;

@end
