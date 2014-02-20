//
//  CHwebViewController.h
//  ece1778_a4
//
//  Created by Craig Hagerman on 2/16/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHwebViewController : UIViewController <UIWebViewDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property NSUInteger pageIndex;
@property NSString *searchTerm;


@end
