//
//  NineAppDelegate.h
//  Nine
//
//  Created by Just Think on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NineScreenAViewController.h"

@interface NineAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIScrollView *bgScrollView;
	//UIImageView *featureImage;
	UIButton *episodesButton;
	UIButton *blogsButton;
	UIButton *socialButton;
	NineScreenAViewController *episodesViewController;
	
	
	UINavigationController *mainNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIScrollView	*bgScrollView;
//@property (nonatomic, retain) IBOutlet UIImageView *featureImage;
@property (nonatomic, retain) IBOutlet UINavigationController *mainNavigationController;
@property (nonatomic, retain) NineScreenAViewController *episodesViewController;

//@property (nonatomic, retain) IBAction UIButton *featureScreenAButton;

-(IBAction) episodesScreenLoad:(UIButton *)sender;
-(IBAction) blogsScreenLoad:(UIButton *)sender;
-(IBAction) socialScreenLoad:(UIButton *)sender;

@end
