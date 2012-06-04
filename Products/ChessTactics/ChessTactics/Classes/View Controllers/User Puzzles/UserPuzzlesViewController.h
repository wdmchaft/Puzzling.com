//
//  UserPuzzlesViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/14/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPuzzlesViewController : UITableViewController

@property (nonatomic, readwrite, retain) NSArray *tactics;

- (void)downloadPuzzles;

@end
