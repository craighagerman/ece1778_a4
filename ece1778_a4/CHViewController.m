//
//  CHViewController.m
//  ece1778_a4
//
//  Created by Craig Hagerman on 2/9/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import "Record.h"
#import "CHAppDelegate.h"
#import "CHViewController.h"
#import "ViewController.h"


@interface CHViewController ()
@property (strong, nonatomic) NSArray *nameArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation CHViewController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    // Create the data model
    _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];
    //_pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.dataSource = self;
    
    CHwebViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    */
    
    
    //1
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 

- (IBAction)populateButtonPressed:(id)sender
{
    [self.spinner startAnimating];
    // spawn a thread to handle accessing URL and populating database
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL  *url = [NSURL URLWithString:self.DBURL.text];
        NSError *error = nil;
        NSStringEncoding encoding;
        NSString *urlData = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&error];
        self.nameArray = [urlData componentsSeparatedByString:@"\n"];
        [self addNamesToDB:self.nameArray];
        // communicate with the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            [self displayAlert];
        });
    });
}


-(void)displayAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"The database has been loaded" message:nil
                          delegate:nil
                          cancelButtonTitle:@"Okay" otherButtonTitles:nil
                          ];
    [alert show];
}


-(NSUInteger)objectExists:(NSString *)person
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", person];
    [request setPredicate:predicate];
    
    NSError *error;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    
    if (!error){
        //NSLog(@"entry %@ exists", person);
        return count;
    }
    else
        return -1;
}


- (void)addNamesToDB:(NSArray *)nArr
{
    Record * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                      inManagedObjectContext:self.managedObjectContext];
    for (NSString *person in nArr) {
        if (( ![person isEqualToString:@""]) && ( [self objectExists:person] > 0 )) {
            newEntry.name = person;
            //NSLog(@"person: %@ added", person);
        }
    }

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
}



- (IBAction)searchButtonPressed:(id)sender {
    //ViewController *uvc = [[ViewController alloc] init];
    //[self.navigationController pushViewController:uvc animated:YES];
    
    
    
    
    /*
    CHwebViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    */
    
}









/*

- (CHwebViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    CHwebViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
    //cvc.imageFile = self.pageImages[index];
    cvc.titleText = self.pageTitles[index];
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
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}



- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

*/

@end
