//
//  CHViewController.h
//  ece1778_a4
//
//  Created by Craig Hagerman on 2/9/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHwebViewController.h"

//@interface CHViewController : UIViewController <UIPageViewControllerDataSource>
@interface CHViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *DBURL;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

//@property (strong, nonatomic) UIPageViewController *pageViewController;
//@property (strong, nonatomic) NSArray *pageTitles;
//@property (strong, nonatomic) NSArray *pageImages;

- (IBAction)populateButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;

@end
