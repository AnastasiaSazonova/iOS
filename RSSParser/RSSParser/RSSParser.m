//
//  RSSParser.m
//  RSSParser
//
//  Created by Anastasia on 3/21/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "RSSParser.h"

NSString * channel = @"channel";
NSString * item = @"item";
NSString * title = @"title";
NSString * description = @"description";
NSString * pubDate = @"pubDate";
NSString * url = @"link";

@implementation RSSParser

-(NSMutableArray *)items
{
    if (!_items)
    {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.rootElement = nil;
    self.currentElementPointer = nil;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                         namespaceURI:(NSString *)namespaceURI
                                        qualifiedName:(NSString *)qName
                                           attributes:(NSDictionary *)attributeDict
{
    if (self.rootElement == nil)
    {
        self.rootElement = [[XmlElement alloc] init];
        self.currentElementPointer = self.rootElement;
    }
    else if ([elementName isEqualToString:channel])
    {
        self.currentItem = [[Item alloc] init];
        self.currentItem.name = channel;
    }

    else if ([elementName isEqualToString:item])
    {
        if (self.currentItem != nil && [self.currentItem.name isEqualToString:item])
        {
             [self.items addObject:self.currentItem];
        }
        self.currentItem = [[Item alloc] init];
        self.currentItem.name = item;
    }
    else
    {
        XmlElement *newElement = [[XmlElement alloc] init];
        newElement.parent = self.currentElementPointer;
        self.currentElementPointer = newElement;
    }
    self.currentElementPointer.name = elementName;
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.currentElementPointer.text length] > 0)
    {
        self.currentElementPointer.text = [self.currentElementPointer.text stringByAppendingString:string];
    }
    else
    {
        self.currentElementPointer.text = string;
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                       namespaceURI:(NSString *)namespaceURI
                                      qualifiedName:(NSString *)qName
{
    if ([self.currentElementPointer.parent.name isEqualToString:channel] && [elementName isEqualToString:title])
    {
        self.mainTitle = self.currentElementPointer.text;
        return;
    }
    if ([elementName isEqualToString:title])
    {
        self.currentItem.title = self.currentElementPointer.text;
    }
    else if ([elementName isEqualToString:description])
    {
        self.currentItem.description = self.currentElementPointer.text;
    }
    else if ([elementName isEqualToString:pubDate])
    {
        self.currentItem.pubDate = self.currentElementPointer.text;
    }
    else if ([elementName isEqualToString:url])
    {
        self.currentItem.link = [NSURL URLWithString:self.currentElementPointer.text];
    }
    self.currentElementPointer = self.currentElementPointer.parent;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.currentElementPointer = nil;
}

@end
