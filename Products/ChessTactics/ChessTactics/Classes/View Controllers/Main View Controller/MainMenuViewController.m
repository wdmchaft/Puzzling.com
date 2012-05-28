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
#import "PuzzleCurrentUser.h"
#import "ConstantsForUI.h"
#import "InfoViewController.h"
#import "FlaggedPuzzlesViewController.h"
#import "TacticsDataConstants.h"


#define LOGOUT @"Logout"
#define INFO @"Info"

@interface MainMenuViewController() <UIActionSheetDelegate, UIAlertViewDelegate> {
	IBOutlet UIButton *__tacticsButton;
	IBOutlet UIButton *__createButton;
	IBOutlet UIButton *__userButton;
	IBOutlet UIButton *__leaderboardButton;
	UIButton *__moderatorButton;
}

@property (nonatomic, readonly, retain) UIButton *tacticsButton;
@property (nonatomic, readonly, retain) UIButton *createButton;
@property (nonatomic, readonly, retain) UIButton *userButton;
@property (nonatomic, readonly, retain) UIButton *leaderBoardButton;
@property (nonatomic, readwrite, retain) UIButton *moderatorButton;

- (void)menuButtonPressed:(id)sender;
- (void)showLoginViewController:(BOOL)animated;
- (void)flaggedPressed:(id)sender;

@end

@implementation MainMenuViewController

@synthesize tacticsButton = __tacticsButton, createButton = __createButton, userButton = __userButton, leaderBoardButton = __leaderboardButton, moderatorButton = __moderatorButton;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Tactics";
		
	if (![PuzzleCurrentUser currentUser].isLoggedIn)
	{
		[self showLoginViewController:NO];
	}
	
	[self.tacticsButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.createButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.userButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.leaderBoardButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
	
	UIBarButtonItem *menuButton = [[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(menuButtonPressed:)] autorelease];
	self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([[[PuzzleCurrentUser currentUser].userData objectForKey:MODERATOR] boolValue])
	{
		self.moderatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.moderatorButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
		[self.moderatorButton setTitle:@"Moderate Flagged Tactics" forState:UIControlStateNormal];
		[self.moderatorButton addTarget:self action:@selector(flaggedPressed:) forControlEvents:UIControlEventTouchUpInside];
		self.moderatorButton.frame = CGRectMake(20, self.view.frame.size.height-44-20, self.view.frame.size.width-40, 44);
		[self.view addSubview:self.moderatorButton];
	}
	else
	{
		[self.moderatorButton removeFromSuperview];
		self.moderatorButton = nil;
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self.moderatorButton removeFromSuperview];
	self.moderatorButton = nil;
}

- (void)dealloc
{
	[__tacticsButton release];
	__tacticsButton = nil;
	[__createButton release];
	__createButton = nil;
	[__userButton release];
	__userButton = nil;
	[__leaderboardButton release];
	__leaderboardButton = nil;
	[__moderatorButton release];
	__moderatorButton = nil;
	
	[super dealloc];
}

- (void)showLoginViewController:(BOOL)animated
{
	LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
	UINavigationController *navCon = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
	UIImage *navBarImage = [UIImage imageNamed: @"NavBar-Wood"];
	[navCon.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
	navCon.navigationBar.tintColor = [UIColor brownColor];
	[self presentModalViewController:navCon animated:animated];
}

- (void)menuButtonPressed:(id)sender
{
	UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:LOGOUT otherButtonTitles:INFO, nil] autorelease];
	[sheet showInView:self.view];
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

- (void)flaggedPressed:(id)sender
{
	FlaggedPuzzlesViewController *vc = [[[FlaggedPuzzlesViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:LOGOUT])
	{
		[[[[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease] show];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:INFO])
	{
		InfoViewController *vc = [[[InfoViewController alloc] init] autorelease];
		UINavigationController *navCon = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
		UIImage *navBarImage = [UIImage imageNamed: @"NavBar-Wood"];
		[navCon.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
		navCon.navigationBar.tintColor = [UIColor brownColor];
		[self presentModalViewController:navCon animated:YES];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"])
	{
		[PuzzleCurrentUser logout];
		[self showLoginViewController:YES];
	}
}

@end
