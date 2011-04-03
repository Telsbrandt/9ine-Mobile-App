//
//  NineAppDelegate.m
//  Nine
//
//  Created by Just Think on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NineAppDelegate.h"

@implementation NineAppDelegate

@synthesize ghettoGlobals;
@synthesize window;
@synthesize overviewVC;
@synthesize recentEpisodeVC;
@synthesize fadeAnimDur;


#pragma mark -
#pragma mark Fake Constants
-(float) fadeAnimDur { return 0.5; }


#pragma mark -
#pragma mark Utility
-(void) assignTagsToSubviews:(UIView*)view
{
    int i = 0;
    for (UIView *subview in view.subviews) {
        subview.tag = i;
        i++;
    }
}

-(void) enableUserInteractionForView:(UIView *)view
{
    view.userInteractionEnabled = YES;
}

-(void) disableGlobalUserInteraction
{
    window.userInteractionEnabled = NO;
}

-(void) enableGlobalUserInteraction
{
    window.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark State Transition Methods
-(void) fadeFromView:(UIView*)fromView toViewControlledBy:(UIViewController*)toViewVC fromViewOnTop:(BOOL)fromViewOnTop
{
    NSLog(@"NineAppDelegate fadeFromView");
    //if ([[toViewVC class] instancesRespondToSelector:@selector(preloadSetup)] == YES) {
    if ([toViewVC  respondsToSelector:@selector(preloadSetup)] == YES) {    
        NSLog(@"NineAppDelegate fadeFromView toView responded to selector preloadSetup");
        NSMethodSignature * mySignature = 
        [toViewVC methodSignatureForSelector:@selector(preloadSetup)];
        
        NSInvocation * myInvocation = 
        [NSInvocation invocationWithMethodSignature:mySignature];
        
        [myInvocation setTarget:toViewVC];
        [myInvocation setSelector:@selector(preloadSetup)];
        
        [self fadeFromView:fromView toView:toViewVC.view afterInvoking:myInvocation fromViewOnTop:fromViewOnTop];
    } else {
        [self fadeFromView:fromView toView:toViewVC.view afterInvoking:nil fromViewOnTop:fromViewOnTop];
    }
}

-(void) fadeFromView:(UIView*)fromView toView:(UIView*)toView fromViewOnTop:(BOOL)fromViewOnTop
{
    [self fadeFromView:fromView toView:toView afterInvoking:nil fromViewOnTop:fromViewOnTop];
}

-(void) fadeFromView:(UIView*)fromView toView:(UIView*)toView afterInvoking:(NSInvocation *)invokation fromViewOnTop:(BOOL)fromViewOnTop
{
    fromView.userInteractionEnabled = NO;
    toView.userInteractionEnabled = NO;
    [self disableGlobalUserInteraction];
    
    toView.alpha = 0.0f;
    [window addSubview:toView];
    toView.userInteractionEnabled = NO;
    
    if (fromViewOnTop) {
        [window bringSubviewToFront:fromView];
        fromView.userInteractionEnabled = NO;
        toView.alpha = 1.0f;
    } 
    
    if (invokation != nil) {
        NSLog(@"\ninvokation invoke\n");
        [invokation invoke];
    }
        
    [UIView beginAnimations:@"FadeToNewView" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:self.fadeAnimDur];
    
    if (fromViewOnTop) {
        fromView.alpha = 0.0f;
    } else {
        toView.alpha = 1.0;
    }
    
    [UIView commitAnimations];
    fromView.userInteractionEnabled = NO;
    
    
    NSMethodSignature * mySignature = 
    [UIView methodSignatureForSelector:
     @selector(transitionFromView:toView:duration:options:completion:)];
    NSInvocation * myInvocation = 
    [NSInvocation invocationWithMethodSignature:mySignature];
    
    UIViewAnimationOptions options = UIViewAnimationTransitionNone;
    float transDur = self.fadeAnimDur;
    float delayDur = 0.0;
    
    [myInvocation setTarget:[UIView class]];
    [myInvocation setSelector:@selector(transitionFromView:toView:duration:options:completion:)];
    [myInvocation setArgument:&fromView atIndex:2];
    [myInvocation setArgument:&toView atIndex:3];
    [myInvocation setArgument:&delayDur atIndex:4];
    [myInvocation setArgument:&options atIndex:5];
    
    [myInvocation performSelector:@selector(invoke) withObject:nil afterDelay:transDur];
    
    float totalTransDur = self.fadeAnimDur + transDur;
    [self performSelector:@selector(enableUserInteractionForView:) withObject:toView afterDelay:totalTransDur];
    [self performSelector:@selector(enableGlobalUserInteraction) withObject:nil afterDelay:totalTransDur];
    
    //toVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentModalViewController:toVC animated:YES];
    
    
    /*[UIView transitionFromView: self.view
     toView: toVC.view
     duration: 0.0 
     options: UIViewAnimationTransitionNone
     completion: NULL];*/
}


-(RecentEpisodeVC*) recentEpisodeVC {
    if (recentEpisodeVC ==nil) {
        recentEpisodeVC = [[RecentEpisodeVC alloc] initWithNibName: @"RecentEpisodeVC" bundle:nil];
    }

	return recentEpisodeVC;
}

-(OverviewVC*) overviewVC {
    if (overviewVC ==nil) {
        overviewVC = [[OverviewVC alloc] initWithNibName: @"OverviewVC" bundle:nil];
    }

	return overviewVC;
}

-(NSMutableDictionary*) ghettoGlobals {
    if (ghettoGlobals ==nil) {
        ghettoGlobals = [[NSMutableDictionary alloc] init];
    }
    
	return ghettoGlobals;
}

/*- (CGSize)contentSizeForBGScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = bgScrollView.bounds;
	NSLog(@"bounds size width and height %f,%f",bounds.size.width, bounds.size.height);
    return CGSizeMake(bounds.size.width, bounds.size.height);
}*/



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	[self.window addSubview:self.overviewVC.view];
	[self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [ghettoGlobals release];
    [window release];
    [overviewVC release];
    [recentEpisodeVC release];
    
    [ghettoGlobals release];
    
    [super dealloc];
}


@end
