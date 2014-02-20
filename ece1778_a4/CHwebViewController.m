//
//  CHwebViewController.m
//  ece1778_a4
//
//  Created by Craig Hagerman on 2/16/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import "CHwebViewController.h"

@interface CHwebViewController ()

@end

@implementation CHwebViewController
//@synthesize titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    
    NSArray *searchArray = [self.searchTerm componentsSeparatedByString:@" "];
    NSString *searchString = [searchArray componentsJoinedByString:@"+"];
    
    NSString *google = @"http://google.ca/search?q=";
    NSString *urlString = [google stringByAppendingString:searchString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];

    [self.webView loadRequest:requestURL];
    
    self.webView.scrollView.scrollEnabled = TRUE;
    self.webView.scalesPageToFit = TRUE;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
