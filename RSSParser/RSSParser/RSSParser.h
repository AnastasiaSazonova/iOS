//
//  RSSParser.h
//  RSSParser
//
//  Created by Anastasia on 3/21/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlElement.h"
#import "Item.h"

@interface RSSParser : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong)NSXMLParser * xmlparser;
@property (nonatomic, strong) XmlElement *rootElement;
@property (nonatomic, strong) XmlElement *currentElementPointer;
@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) Item * currentItem;
@property (nonatomic, strong) NSString * mainTitle;

@end
