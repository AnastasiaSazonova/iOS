//
//  RSSFeedViewController.m
//  RSSParser
//
//  Created by Anastasia on 3/21/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "RSSFeedViewController.h"
#import "RSSParser.h"
#import "WebViewController.h"

@interface RSSFeedViewController ()

@property(nonatomic, strong)NSXMLParser * xmlparser;
@property(nonatomic, strong)NSMutableArray * arrayOfArticles;

@end

@implementation RSSFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL * rssURL = [NSURL URLWithString:@"http://events.dev.by/rss"];
    NSData * xmlData = [[NSData alloc] initWithContentsOfURL:rssURL];
    self.xmlparser = [[NSXMLParser alloc] initWithData:xmlData];
    RSSParser * parser = [[RSSParser alloc] init];
    self.xmlparser.delegate = parser;
    if ([self.xmlparser parse])
    {
        self.arrayOfArticles = parser.items;
        if ([parser.mainTitle length] != 0)
        {
            self.navigationItem.title = parser.mainTitle;
        }
        else
        {
            self.navigationItem.title = @"RSS";
        }
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfArticles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Item * currentItem = self.arrayOfArticles[indexPath.row];
    cell.textLabel.text = currentItem.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Posted on: %@", currentItem.pubDate];
    return cell;
}

#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[WebViewController class]])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        Item * currentItem = self.arrayOfArticles[indexPath.row];
        [segue.destinationViewController setArticlesURL:currentItem.link];
    }
}

@end






