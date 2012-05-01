//
//  PlayPuzzleViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/30/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PlayPuzzleViewController.h"
#import "ChessBoardViewController.h"
#import "PuzzleSDK.h"


@interface PlayPuzzleViewController () {
	ChessBoardViewController *__chessBoardViewController;
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;

@end

@implementation PlayPuzzleViewController

@synthesize chessBoardViewController = __chessBoardViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//	self.chessBoardViewController = [[[ChessBoardViewController alloc] initWithColor:self.playerColor] autorelease];
//	self.chessBoardViewController.inEditingMode = NO;
//	self.chessBoardViewController.delegate = self;
//	self.chessBoardViewController.fullBoard = NO;
//	[self.view addSubview:self.chessBoardViewController.view];
	
	
}

@end
