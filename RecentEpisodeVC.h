//
//  NineScreenAViewController.h
//  Nine
//
//  Created by Just Think on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentEpisodeVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

-(IBAction) switchToOverview;

@end
