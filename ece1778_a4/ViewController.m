//
//  ViewController.m
//  ece1778_a4
//
//  Created by Craig Hagerman on 2/9/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import "Record.h"
#import "CHAppDelegate.h"
#import "ViewController.h"


@interface ViewController ()
@property (strong, nonatomic) NSArray *nameArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSArray* fetchedRecordsArray;
@property (readwrite, assign) NSUInteger recordCount;
@end

@implementation ViewController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedRecordsArray = [appDelegate getAllRecords];
    
    self.recordCount = [self.fetchedRecordsArray count];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.dataSource = self;
    
    CHwebViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 10);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 


- (CHwebViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((self.recordCount == 0) || (index >= self.recordCount)) {
        return nil;
    }
    Record * record = [self.fetchedRecordsArray objectAtIndex:index];
    
    // Create a new view controller and pass suitable data.
    CHwebViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
    cvc.searchTerm = record.name;
    cvc.pageIndex = index;
    return cvc;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((CHwebViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((CHwebViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == self.recordCount) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}



- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.recordCount;
}


- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}



@end
