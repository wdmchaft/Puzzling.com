//
//  PlayPuzzleViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/30/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PlayPuzzleViewController.h"
#import "ChessBoardViewController.h"
#import "PuzzleDownloader.h"
#import "TacticsDataConstants.h"


@interface PlayPuzzleViewController () <ChessBoardViewControllerDelegate> {
	ChessBoardViewController *__chessBoardViewController;
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;

- (void)setupPuzzle:(PuzzlePuzzle *)puzzle;

@end

@implementation PlayPuzzleViewController

@synthesize chessBoardViewController = __chessBoardViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[PuzzleDownloader sharedInstance] downloadPuzzleWithCallback:^(PuzzlePuzzle * puzzle) {
		[self setupPuzzle:puzzle];
	}];
}

#pragma mark - Private Methods

- (void)setupPuzzle:(PuzzlePuzzle *)puzzle {
	id temp = puzzle; //FIXME: remove when puzzle starts working
	
	NSDictionary *setupData = [temp objectForKey:@"setupData"];
	
	Color playerColor = -1;
	if ([[setupData objectForKey:PLAYER_COLOR] isEqualToString:WHITE]) {
		playerColor = kWhite;
	} else if ([[setupData objectForKey:PLAYER_COLOR] isEqualToString:BLACK]) {
		playerColor = kBlack;
	}
	
	self.chessBoardViewController = [[[ChessBoardViewController alloc] initWithColor:playerColor] autorelease];
	self.chessBoardViewController.inEditingMode = NO;
	self.chessBoardViewController.delegate = self;
	self.chessBoardViewController.fullBoard = NO;
	[self.view addSubview:self.chessBoardViewController.view];
}

@end
