//
//  MainMenuViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CreatePuzzleSetupViewController.h"
#import "PlayPuzzleViewController.h"
#import "UserPuzzlesViewController.h"
#import "PuzzleCurrentUser.h"
#import "LoginViewController.h"
#import "LeaderboardsViewController.h"


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Tactics";
	
	if (![PuzzleCurrentUser currentUser].isLoggedIn)
	{
		LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
		UINavigationController *navCon = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
		navCon.navigationBar.tintColor = [UIColor blackColor];
		[self presentModalViewController:navCon animated:NO];
	}
}

- (IBAction)playPuzzlePressed:(id)sender {
	PlayPuzzleViewController *puzzleViewController = [[[PlayPuzzleViewController alloc] initWithRated:YES] autorelease];
	[self.navigationController pushViewController:puzzleViewController animated:YES];
}

- (IBAction)createPuzzlePressed:(id)sender {
	CreatePuzzleSetupViewController *vc = [[[CreatePuzzleSetupViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)userPuzzlesPressed:(id)sender {
	UserPuzzlesViewController *vc = [[[UserPuzzlesViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)leaderboardsPressed:(id)sender
{
	LeaderboardsViewController *vc = [[[LeaderboardsViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
