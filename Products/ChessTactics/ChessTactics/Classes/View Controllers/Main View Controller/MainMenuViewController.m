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


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Tactics";
}

- (IBAction)playPuzzlePressed:(id)sender {
	PlayPuzzleViewController *puzzleViewController = [[[PlayPuzzleViewController alloc] init] autorelease];
	[self.navigationController pushViewController:puzzleViewController animated:YES];
}

- (IBAction)createPuzzlePressed:(id)sender {
	CreatePuzzleSetupViewController *vc = [[[CreatePuzzleSetupViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
