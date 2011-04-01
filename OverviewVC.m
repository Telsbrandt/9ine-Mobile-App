//
//  OverviewVC.m
//  Nine
//
//  Created by Patrick Felong on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OverviewVC.h"
#import "NineAppDelegate.h"


@implementation OverviewVC;

@synthesize bgScrollView;

-(IBAction) switchToRecentEpisodeView {
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    [UIView transitionFromView: self.view 
                        toView: del.recentEpisodeVC.view 
                      duration: 0.5 
                       options: UIViewAnimationTransitionFlipFromLeft 
                    completion: NULL];
}

- (CGSize)contentSizeForBGScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = bgScrollView.bounds;
    NSLog(@"bounds size width and height %f,%f",bounds.size.width, bounds.size.height);
    return CGSizeMake(bounds.size.width, bounds.size.height);
}

#pragma mark - Memory Management
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    //self.bgScrollView.delegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image = [UIImage imageNamed:@"9ine_320x45pts.png"];
    
    //	UIImage *image_old = [UIImage imageNamed:@"9ine_iphone_bg.png"];
    //	UIImageView *imageView  = [[UIImageView alloc] initWithImage:image];
    //	//get application frame;
    //	
    //	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    //	
    //	//put image ina scroll view;
    //	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    //	scrollView.contentSize = image_old.size;
    //	scrollView.backgroundColor = [UIColor blackColor];
    //	scrollView.showsVerticalScrollIndicator = NO;
    //    scrollView.showsHorizontalScrollIndicator = NO;
    //	[scrollView addSubview:imageView];
    //	
    //	[window addSubview:scrollView];
	
	//[window addSubview:imageView];
	
	
	//
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	
    // bgScrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
	
	bgScrollView.scrollEnabled = YES;
	//bgScrollView.showsVerticalScrollIndicator = YES;
	//bgScrollView.showsHorizontalScrollIndicator = YES;
	bgScrollView.directionalLockEnabled = YES;
	
	//
	
	//bgScrollView.frame =CGRectMake(bgScrollView.bounds.origin.x, bgScrollView.bounds.origin.x, image.size.width, image.size.height);
	bgScrollView.frame = applicationFrame;
	//bgScrollView.contentSize.height = image.size.height;
	bgScrollView.contentSize = image.size;
    [self.view addSubview: bgScrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
