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


#pragma mark - 
#pragma mark Transition Methods
-(void) scaleUpSubview:(UIView *)subview fadeToView:(UIView *)toView 
{
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary* gGlobs = del.ghettoGlobals;
    
    float animationDuration = 0.5f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:animationDuration];
    
    NSNumber* savedCenterX = [NSNumber numberWithFloat:subview.center.x];
    NSNumber* savedCenterY = [NSNumber numberWithFloat:subview.center.y];
    
    
    [gGlobs setObject:savedCenterX forKey:@"OverviewSubviewSavedCenterX"];
    [gGlobs setObject:savedCenterY forKey:@"OverviewSubviewSavedCenterY"];
    
    subview.center = CGPointMake(bgScrollView.contentOffset.x + (self.view.frame.size.width / 2), (bgScrollView.contentSize.height / 2));
    
    
	subview.transform = CGAffineTransformIdentity;
    
    float widthScale = (1.0 / subview.frame.size.width) * self.view.frame.size.width;
    float heightScale = (1.0 / subview.frame.size.height) * self.view.frame.size.height;
    
    CGAffineTransform subToSuperScale = CGAffineTransformMakeScale(widthScale, heightScale);
    subview.transform = subToSuperScale;

    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    [UIView commitAnimations];


    UIView * selfView = self.view;
    NSMethodSignature * mySignature = [NineAppDelegate 
                                       instanceMethodSignatureForSelector:@selector(fadeFromView:toView:)];
    NSInvocation * myInvocation = [NSInvocation
                                   invocationWithMethodSignature:mySignature];
    [myInvocation setTarget:del];
    [myInvocation setSelector:@selector(fadeFromView:toView:)];
    [myInvocation setArgument:&selfView atIndex:2];
    [myInvocation setArgument:&toView atIndex:3];

    [myInvocation performSelector:@selector(invoke) withObject:nil afterDelay:animationDuration];
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
    [bgScrollView release];
    
    [recentEpisodeMiniView release];
    [blogMiniView release];
    [socialMiniView release];
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
    
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary* gGlobs = del.ghettoGlobals;
    
    [gGlobs setValue:YES forKey:@"OverviewVCHasLoaded"];
    
    
    
    bgScrollView.contentOffset = CGPointMake((bgScrollView.contentSize.width / 2) - (self.view.frame.size.width / 2), 0);
    
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
