//
//  CreatePuzzleSetupViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/29/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "CreatePuzzleSetupViewController.h"
#import "ChessPieces.h"
#import "CreatePuzzleViewController.h"
#import "TacticsDataConstants.h"


#define FULL_BOARD @"Full Board"
#define EMPTY_BOARD @"Empty Board"
#define WHITE_LABEL @"White"
#define BLACK_LABEL @"Black"

@interface CreatePuzzleSetupViewController () {
	Color __color;
	BOOL __fullBoard;
	
	IBOutlet UISwitch *__computerMovesFirst;
}

@property (nonatomic, readwrite, assign) Color color;
@property (nonatomic, readwrite, assign) BOOL fullBoard;
@property (nonatomic, readwrite, retain) UISwitch *computerMovesFirst;

- (IBAction)changeColor:(UIButton *)sender;
- (IBAction)changeBoard:(UIButton *)sender;
- (IBAction)go:(UIButton *)sender;

@end

@implementation CreatePuzzleSetupViewController

@synthesize color = __color, fullBoard = __fullBoard, computerMovesFirst = __computerMovesFirst;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Select Options";
	
	self.fullBoard = NO;
	self.color = kWhite;
}

- (void)dealloc {
	[__computerMovesFirst release];
	__computerMovesFirst = nil;
	
	[super dealloc];
}

- (IBAction)changeColor:(UIButton *)sender {
	if (self.color == kWhite) {
		[sender setTitle:BLACK_LABEL forState:UIControlStateNormal];
		self.color = kBlack;
	} else {
		[sender setTitle:WHITE_LABEL forState:UIControlStateNormal];
		self.color = kWhite;		
	}
}

- (IBAction)changeBoard:(UIButton *)sender {
	if (self.fullBoard) {
		[sender setTitle:EMPTY_BOARD forState:UIControlStateNormal];
		self.fullBoard = NO;
	} else {
		[sender setTitle:FULL_BOARD forState:UIControlStateNormal];
		self.fullBoard = YES;
	}
}

- (IBAction)go:(UIButton *)sender {
	CreatePuzzleViewController *vc = [[[CreatePuzzleViewController alloc] init] autorelease];
	vc.fullBoard = self.fullBoard;
	vc.playerColor = self.color;
	vc.computerMoveFirst = self.computerMovesFirst.on;
	[self.navigationController pushViewController:vc animated:YES];
}

@end
