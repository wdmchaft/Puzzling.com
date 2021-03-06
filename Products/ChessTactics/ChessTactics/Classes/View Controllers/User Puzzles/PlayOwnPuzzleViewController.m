//
//  PlayOwnPuzzleViewControllerViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/18/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "PlayOwnPuzzleViewController.h"

@interface PlayOwnPuzzleViewController ()

@end

@implementation PlayOwnPuzzleViewController

- (id)init
{
	self = [super initWithNibName:@"PlayPuzzleViewController" bundle:nil];
	if (self)
	{
		self.rated = NO;
	}
	return self;
}

- (void)endTactic:(double)score {
	[super endTactic:score];
	
	self.navigationItem.rightBarButtonItem = nil; //There is no next tactic so remove button
}

- (void)showAlertViewForSuccess
{
	[[[[UIAlertView alloc] initWithTitle:@"Success" message:@"Well done. Correct solution." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

@end
