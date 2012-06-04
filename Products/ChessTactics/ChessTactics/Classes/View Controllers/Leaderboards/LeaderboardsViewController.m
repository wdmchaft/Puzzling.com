//
//  LeaderboardsViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/23/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "LeaderboardsViewController.h"
#import "UsersRatingLeaderboardTableViewController.h"
#import "ConstantsForUI.h"
#import "PuzzlesRatingLeaderboardViewController.h"
#import "PuzzlesLikesLeaderboardViewController.h"


@interface LeaderboardsViewController () {
	IBOutlet UIButton *__userButton;
	IBOutlet UIButton *__tacticsRatedButton;
	IBOutlet UIButton *__tacticsLikedButton;
}

@property (nonatomic, readonly, retain) UIButton *userButton;
@property (nonatomic, readonly, retain) UIButton *tacticsRatedButton;
@property (nonatomic, readonly, retain) UIButton *tacticsLikedButton;

- (IBAction)usersPressed:(id)sender;

@end

@implementation LeaderboardsViewController

@synthesize userButton = __userButton,tacticsLikedButton = __tacticsLikedButton, tacticsRatedButton = __tacticsRatedButton;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"Leaderboards";
	self.view.backgroundColor = BACKGROUND_COLOR;
	
//	[self.userButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.tacticsRatedButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.tacticsLikedButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
}

- (void)dealloc
{
	[__userButton release];
	__userButton = nil;
	[__tacticsLikedButton release];
	__tacticsLikedButton = nil;
	[__tacticsRatedButton release];
	__tacticsRatedButton = nil;
	
	[super dealloc];
}

- (IBAction)usersPressed:(id)sender
{
	UsersRatingLeaderboardTableViewController *vc = [[[UsersRatingLeaderboardTableViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)puzzlesRatingPressed:(id)sender
{
	PuzzlesRatingLeaderboardViewController *vc = [[[PuzzlesRatingLeaderboardViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)puzzlesMostLikedPressed:(id)sender
{
	PuzzlesLikesLeaderboardViewController *vc = [[[PuzzlesLikesLeaderboardViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
