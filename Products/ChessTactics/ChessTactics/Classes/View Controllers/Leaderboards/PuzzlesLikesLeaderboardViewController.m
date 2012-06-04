//
//  PuzzlesLikesLeaderboardViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 6/3/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzlesLikesLeaderboardViewController.h"
#import "PuzzleSDK.h"


@interface PuzzlesLikesLeaderboardViewController ()

@end

@implementation PuzzlesLikesLeaderboardViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"20 Most Liked Tactics";
}

- (void)downloadPuzzles
{
	[[PuzzleSDK sharedInstance] getLeaderboardForPuzzlesLikesOnCompletion:^(PuzzleAPIResponse response, NSArray *puzzles) 
	 {
		 if (response == PuzzleOperationSuccessful) 
		 {
			 self.tactics = puzzles;
			 [self.tableView reloadData];
		 } 
		 else
		 {
			 [PuzzleErrorHandler presentErrorForResponse:response];
		 }
	 }];
}

@end
