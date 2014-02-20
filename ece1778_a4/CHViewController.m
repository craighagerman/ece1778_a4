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
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation CHViewController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchButton setEnabled:NO];
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
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
            [self.searchButton setEnabled:YES];
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
        return count;
    }
    else
        return -1;
}


- (void)addNamesToDB:(NSArray *)nArr
{
    for (NSString *person in nArr) {
        if (( ![person isEqualToString:@""]) && ( [self objectExists:person] <= 0 )) {
            Record * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                              inManagedObjectContext:self.managedObjectContext];
            newEntry.name = person;
        }
    }
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
}



- (IBAction)searchButtonPressed:(id)sender {
    // handled by storyboard segue
}


#pragma mark - methods to show / dismiss keyboard on background tap

-(void) keyboardWillShow:(NSNotification *) note
{
    [self.view addGestureRecognizer:self.tapRecognizer];
}


-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
}


-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [self.DBURL resignFirstResponder];
}


@end
