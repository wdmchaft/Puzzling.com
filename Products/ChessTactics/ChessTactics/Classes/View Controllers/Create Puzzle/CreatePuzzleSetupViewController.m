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


#define FULL_BOARD @"Full Board"
#define EMPTY_BOARD @"Empty Board"
#define WHITE @"White"
#define BLACK @"Black"

@interface CreatePuzzleSetupViewController () {
	Color __color;
	BOOL __fullBoard;
}

@property (nonatomic, readwrite, assign) Color color;
@property (nonatomic, readwrite, assign) BOOL fullBoard;

- (IBAction)changeColor:(UIButton *)sender;
- (IBAction)changeBoard:(UIButton *)sender;
- (IBAction)go:(UIButton *)sender;

@end

@implementation CreatePuzzleSetupViewController

@synthesize color = __color, fullBoard = __fullBoard;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Select Options";
	
	self.fullBoard = YES;
	self.color = kWhite;
}

- (IBAction)changeColor:(UIButton *)sender {
	if (self.color == kWhite) {
		[sender setTitle:BLACK forState:UIControlStateNormal];
		self.color = kBlack;
	} else {
		[sender setTitle:WHITE forState:UIControlStateNormal];
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
	[self.navigationController pushViewController:vc animated:YES];
}

@end
