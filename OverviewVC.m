//
//  OverviewVC.m
//  Nine
//
//  Created by Patrick Felong on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OverviewVC.h"
#import "NineAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation OverviewVC;

@synthesize bgScrollView;
@synthesize recentEpisodeMiniView;
@synthesize blogMiniView;
@synthesize socialMiniView;


#pragma mark - Transition Methods
-(void) scaleUpSubview:(UIView *)subview fadeToView:(UIView *)newView 
{
    float animationDuration = 0.5f;
    //recentEpisodeMiniView.frame = CGRectMake(0.0f, 0.0f, 200.0f, 150.0f);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:animationDuration];
    //recentEpisodeMiniView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    
    CAKeyframeAnimation *moveToCenterAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	
	//CGFloat animationDuration = 0.5f;
    
	
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	CGFloat midX = self.view.center.x;
	CGFloat midY = self.view.center.y;
	
	
	// Start the path at the placard's current location
	CGPathMoveToPoint(thePath, NULL, recentEpisodeMiniView.center.x, recentEpisodeMiniView.center.y);
	CGPathAddLineToPoint(thePath, NULL, midX, midY);
    
    moveToCenterAnim.path = thePath;
    
	
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.removedOnCompletion = YES;
	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    recentEpisodeMiniView.center = self.view.center;
	recentEpisodeMiniView.transform = CGAffineTransformIdentity;
    
    
    float widthScale = (1.0 / recentEpisodeMiniView.frame.size.width) * self.view.frame.size.width;
    float heightScale = (1.0 / recentEpisodeMiniView.frame.size.height) * self.view.frame.size.height;
    
    CGAffineTransform subToSuperScale = CGAffineTransformMakeScale(widthScale, heightScale);
    recentEpisodeMiniView.transform = subToSuperScale;
    
    
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    [UIView commitAnimations];
    
    CGPathRelease(thePath);
    
    //[UIView setAnimationDidStopSelector:@selector(transitionToView: newView)];
    [self performSelector: @selector(transitionToView:)
               withObject: newView
               afterDelay: animationDuration];

}

-(void) transitionToView: (UIView *)toView
{
    [UIView transitionFromView: self.view 
                        toView: toView 
                      duration: 0.5 
                       options: UIViewAnimationTransitionNone
                    completion: NULL];
}

-(IBAction) switchToRecentEpisodeView 
{
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    [self scaleUpSubview: recentEpisodeMiniView fadeToView: del.recentEpisodeVC.view];
}

-(IBAction) switchToBlogView {
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    [UIView transitionFromView: self.view 
                        toView: del.recentEpisodeVC.view 
                      duration: 0.5 
                       options: UIViewAnimationTransitionFlipFromLeft 
                    completion: NULL];
}

-(IBAction) switchToSocialView {
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
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
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
