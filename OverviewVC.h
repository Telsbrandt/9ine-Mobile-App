//
//  OverviewVC.h
//  Nine
//
//  Created by Patrick Felong on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OverviewVC : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *bgScrollView;
    
    IBOutlet UIView *recentEpisodeMiniView;
    IBOutlet UIView *blogMiniView;
    IBOutlet UIView *socialMiniView;
}


@property (nonatomic, retain) IBOutlet UIScrollView *bgScrollView;
@property (nonatomic, retain) IBOutlet UIView *recentEpisodeMiniView;
@property (nonatomic, retain) IBOutlet UIView *blogMiniView;
@property (nonatomic, retain) IBOutlet UIView *socialMiniView;


-(IBAction) switchToRecentEpisodeView;



@end
