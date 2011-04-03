//
//  OverviewVC.m
//  Nine
//
//  Created by Patrick Felong on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OverviewVC.h"
#import "NineAppDelegate.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>


@implementation OverviewVC;

@synthesize bgScrollView;
@synthesize recentEpisodeMiniView;
@synthesize blogMiniView;
@synthesize socialMiniView;
@synthesize scaleAnimDur;


#pragma mark -
#pragma mark Fake Constants
-(float) scaleAnimDur { return 0.5; }


#pragma mark -
#pragma mark Utility
-(void) enableUserInteraction
{
    self.bgScrollView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}


#pragma mark -
#pragma mark Transition Methods
-(void) preloadSetup
{
    NSLog(@"OverviewVC preloadSetup");
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary* gGlobs = del.ghettoGlobals;
    
    if ([gGlobs objectForKey:@"OverviewVCLoadedPreviously"]) {
        NSLog(@"Loaded before");
        // We restore state data here as a precaution because
        // OverviewVC may be unloaded from memory at some point.
        // If a subview was scaled up when Overview was last transitioned from,
        // we want it to "remain" that way when the user returns to the view.
        if ([(NSNumber *)[gGlobs objectForKey:@"SubviewZoomedIn"] boolValue] == YES) 
        {
            NSLog(@"Subview currently zoomed in");
            int tag = [(NSNumber *)[gGlobs objectForKey:@"CurrentlyZoomedSubviewTag"] intValue];
            UIView* zoomedSubview = [self.bgScrollView viewWithTag:tag];
            
            NSString* subviewTransString = [gGlobs objectForKey:
                                            [NSString stringWithFormat:@"OverviewSubview%dSavedZoomTransform", tag]];
            
            CGAffineTransform subviewTransform = 
                CGAffineTransformFromString(subviewTransString);
            
            zoomedSubview.transform = subviewTransform;
            [self.bgScrollView bringSubviewToFront:zoomedSubview];
            [self performSelector:@selector(scaleDownSubview:) withObject:zoomedSubview afterDelay:0.0];
        }
        
        NSNumber* savedOffsetX = [gGlobs objectForKey:@"OverviewScrollContentOffsetX"];
        NSNumber* savedOffsetY = [gGlobs objectForKey:@"OverviewScrollContentOffsetY"];
        
        
        bgScrollView.contentOffset = 
            CGPointMake([savedOffsetX floatValue], [savedOffsetY floatValue]);
    } else {
        NSLog(@"Did not load before");
        bgScrollView.contentOffset = CGPointMake(
                                                 (bgScrollView.contentSize.width / 2) - (self.view.frame.size.width / 2), 0);
        
        [gGlobs setObject:[NSNumber numberWithBool:YES] forKey:@"OverviewVCLoadedPreviously"];
    }
    
    self.bgScrollView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    NSLog(@"%@", gGlobs);
    NSArray *keys = [gGlobs allKeys];
    
    for (NSString *key in keys) {
        NSLog(@"%@ is %@", key, [gGlobs objectForKey:key]);
    }
    
    [self performSelector:@selector(enableUserInteraction) withObject:nil afterDelay:0.5];
}

-(void) scaleUpSubview:(UIView *)subview fadeToView:(UIView *)toView 
{
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    [del disableGlobalUserInteraction];
    
    NSMutableDictionary* gGlobs = del.ghettoGlobals;

    
    // Scale subview to screen size and move it to screen center
    [UIView beginAnimations:@"Scale Up Subview" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:self.scaleAnimDur];
    
    NSNumber* savedCenterX = [NSNumber numberWithFloat:subview.center.x];
    NSNumber* savedCenterY = [NSNumber numberWithFloat:subview.center.y];

    [gGlobs setObject:savedCenterX 
               forKey:[NSString stringWithFormat:@"OverviewSubview%dSavedCenterX", subview.tag]];
    [gGlobs setObject:savedCenterY 
               forKey:[NSString stringWithFormat:@"OverviewSubview%dSavedCenterY", subview.tag]];
    
    
    subview.center = CGPointMake(bgScrollView.contentOffset.x + (self.view.frame.size.width / 2), (bgScrollView.contentSize.height / 2));
	subview.transform = CGAffineTransformIdentity;
    
    float widthScale = (1.0 / subview.frame.size.width) * self.view.frame.size.width;
    float heightScale = (1.0 / subview.frame.size.height) * self.view.frame.size.height;
    
    CGAffineTransform subToSuperScale = CGAffineTransformMakeScale(widthScale, heightScale);
    subview.transform = subToSuperScale;
    
    NSString* savedTransform = NSStringFromCGAffineTransform(subToSuperScale);
    [gGlobs setObject:savedTransform
               forKey:[NSString stringWithFormat:@"OverviewSubview%dSavedZoomTransform", subview.tag]];

    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    [bgScrollView bringSubviewToFront:subview];
    [UIView commitAnimations];
    
    self.bgScrollView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    [gGlobs setObject:[NSNumber numberWithBool:YES] forKey:@"SubviewZoomedIn"];
    [gGlobs setObject:[NSNumber numberWithInt:subview.tag] forKey:@"CurrentlyZoomedSubviewTag"];
    
    
    // Call appdelegate to manage view transition after animation ends
    UIView * selfView = self.view;
    BOOL fromViewOnTop = NO;
    NSMethodSignature * mySignature = 
        [NineAppDelegate instanceMethodSignatureForSelector:@selector(fadeFromView:toView:fromViewOnTop:)];
    NSInvocation * myInvocation = 
        [NSInvocation invocationWithMethodSignature:mySignature];
    [myInvocation setTarget:del];
    [myInvocation setSelector:@selector(fadeFromView:toView:fromViewOnTop:)];
    [myInvocation setArgument:&selfView atIndex:2];
    [myInvocation setArgument:&toView atIndex:3];
    [myInvocation setArgument:&fromViewOnTop atIndex:4];

    [myInvocation performSelector:@selector(invoke) withObject:nil afterDelay:self.scaleAnimDur];
}

-(void) scaleDownSubview:(UIView *)subview 
{
    NSLog(@"Zooming out of subview");
    self.bgScrollView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary* gGlobs = del.ghettoGlobals;
    
    // Scale subview to screen size and move it to screen center
    [UIView beginAnimations:@"Scale Down Subview" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDuration:self.scaleAnimDur];
    
    
    NSNumber* savedCenterX = [gGlobs objectForKey:
        [NSString stringWithFormat:@"OverviewSubview%dSavedCenterX", subview.tag]];
    NSNumber* savedCenterY = [gGlobs objectForKey:
        [NSString stringWithFormat:@"OverviewSubview%dSavedCenterY", subview.tag]];
    
    subview.center = CGPointMake([savedCenterX floatValue], [savedCenterY floatValue]);
    
    
    //NSString* savedTransform = [gGlobs objectForKey:
    //    [NSString stringWithFormat:@"OverviewSubview%dSavedZoomTransform", subview.tag]];
    //CGAffineTransform superToSubScale = CGAffineTransformInvert(CGAffineTransformFromString(savedTransform));
    
	subview.transform = CGAffineTransformIdentity;
    //subview.transform = superToSubScale;
    
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(enableUserInteraction)];
    [UIView commitAnimations];
    [gGlobs setObject:[NSNumber numberWithBool:NO] forKey:@"SubviewZoomedIn"];
}



-(IBAction) switchToRecentEpisodeView 
{
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    [self scaleUpSubview:recentEpisodeMiniView fadeToView:del.recentEpisodeVC.view];
    self.view.userInteractionEnabled = NO;
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


#pragma mark -
#pragma mark Memory Management
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
    [self preloadSetup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"ViewDidAppear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view from its nib.
    
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    
    [del assignTagsToSubviews:bgScrollView];
    
    UIImage *image = [UIImage imageNamed:@"9ine_320x45pts.png"];
    
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	
	bgScrollView.scrollEnabled = YES;
	bgScrollView.directionalLockEnabled = YES;
	
	bgScrollView.frame = applicationFrame;
	bgScrollView.contentSize = image.size;
    
    //[self addEv
    
    
    [self.view addSubview: bgScrollView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    NineAppDelegate* del = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary* gGlobs = del.ghettoGlobals;
    
    NSNumber* savedOffsetX = [NSNumber numberWithFloat:bgScrollView.contentOffset.x];
    NSNumber* savedOffsetY = [NSNumber numberWithFloat:bgScrollView.contentOffset.y];
    
    [gGlobs setObject:savedOffsetX
               forKey:@"OverviewScrollContentOffsetX"];
    [gGlobs setObject:savedOffsetY 
               forKey:@"OverviewScrollContentOffsetY"];
    
   // NSLog(@"OverviewVC viewWillDisappear");
    
    
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
