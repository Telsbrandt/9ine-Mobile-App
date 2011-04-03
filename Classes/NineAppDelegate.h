//
//  NineAppDelegate.h
//  Nine
//
//  Created by Just Think on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticVCs_Prefix.pch"


@interface NineAppDelegate : NSObject <UIApplicationDelegate> {
    NSMutableDictionary* ghettoGlobals;
    UIWindow *window;

	OverviewVC *overviewVC;
    RecentEpisodeVC *recentEpisodeVC;
}


@property (nonatomic, retain) NSMutableDictionary *ghettoGlobals;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) OverviewVC *overviewVC;
@property (nonatomic, retain) RecentEpisodeVC *recentEpisodeVC;

@property (readonly) float fadeAnimDur;


-(void) assignTagsToSubviews:(UIView*)view;
-(void) disableGlobalUserInteraction;
-(void) enableGlobalUserInteraction;

-(void) fadeFromView:(UIView*)fromView toViewControlledBy:(UIViewController*)toViewVC fromViewOnTop:(BOOL)fromViewOnTop;
-(void) fadeFromView:(UIView*)fromView toView:(UIView*)toView fromViewOnTop:(BOOL)fromViewOnTop;
-(void) fadeFromView:(UIView*)fromView toView:(UIView*)toView afterInvoking:(NSInvocation *)invokation fromViewOnTop:(BOOL)fromViewOnTop;


@end
