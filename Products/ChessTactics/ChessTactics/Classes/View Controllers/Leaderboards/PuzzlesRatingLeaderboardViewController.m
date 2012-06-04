//
//  PuzzlesRatingLeaderboardViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 6/3/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzlesRatingLeaderboardViewController.h"
#import "PuzzleSDK.h"
#import "UserPuzzleCell.h"


@interface PuzzlesRatingLeaderboardViewController ()

@end

@implementation PuzzlesRatingLeaderboardViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Toughest 20 Tactics";
}

- (void)downloadPuzzles
{
	[[PuzzleSDK sharedInstance] getLeaderboardForPuzzlesRatingOnCompletion:^(PuzzleAPIResponse response, NSArray *puzzles) 
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
