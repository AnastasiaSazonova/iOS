//
//  WebViewController.m
//  RSSParser
//
//  Created by Anastasia on 3/21/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_articlesURL)
    {
        [self.spinner startAnimating];
        self.webView.delegate = self;
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:self.articlesURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
        {
            if ([data length] > 0 && connectionError == nil)
            {
                [self.webView loadRequest:urlRequest];
            }
            else
            {
                NSLog(@"Error: %@", connectionError);
            }
            
        }];
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
}

@end
