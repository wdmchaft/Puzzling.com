//
//  MainMenuViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CreatePuzzleViewController.h"


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (IBAction)playPuzzlePressed:(id)sender {
	
}

- (IBAction)createPuzzlePressed:(id)sender {
	CreatePuzzleViewController *vc = [[[CreatePuzzleViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
