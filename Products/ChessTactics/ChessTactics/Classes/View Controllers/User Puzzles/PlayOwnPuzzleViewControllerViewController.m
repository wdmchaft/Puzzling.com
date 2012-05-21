//
//  PlayOwnPuzzleViewControllerViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/18/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PlayOwnPuzzleViewControllerViewController.h"

@interface PlayOwnPuzzleViewControllerViewController ()

@end

@implementation PlayOwnPuzzleViewControllerViewController

- (id)init
{
	return [super initWithRated:NO];	
}

- (void)endTactic:(double)score {
	[super endTactic:score];
	
	self.navigationItem.rightBarButtonItem = nil; //There is no next tactic so remove button
}

@end
