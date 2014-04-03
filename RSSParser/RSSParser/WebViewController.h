//
//  WebViewController.h
//  RSSParser
//
//  Created by Anastasia on 3/21/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSURL * articlesURL;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
