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
    UIWindow *window;

	OverviewVC *overviewVC;
    RecentEpisodeVC *recentEpisodeVC;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) OverviewVC *overviewVC;
@property (nonatomic, retain) RecentEpisodeVC *recentEpisodeVC;


@end
