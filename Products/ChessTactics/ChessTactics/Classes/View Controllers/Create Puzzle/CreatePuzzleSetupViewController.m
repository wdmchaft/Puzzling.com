//
//  CreatePuzzleSetupViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/29/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "CreatePuzzleSetupViewController.h"
#import "ChessPieces.h"
#import "CreatePuzzleViewController.h"
#import "TacticsDataConstants.h"
#import "ConstantsForUI.h"
#import "TacticGuidelinesViewController.h"


#define FULL_BOARD @"Full Board"
#define EMPTY_BOARD @"Empty Board"
#define WHITE_LABEL @"White"
#define BLACK_LABEL @"Black"

@interface CreatePuzzleSetupViewController () {
	Color __color;
	BOOL __fullBoard;
	
	IBOutlet UISwitch *__computerMovesFirst;
	IBOutlet UIButton *__startButton;
	IBOutlet UIButton *__colorButton;
	IBOutlet UIButton *__boardButton;
	IBOutlet UIButton *__guidelinesButton;
}

@property (nonatomic, readwrite, assign) Color color;
@property (nonatomic, readwrite, assign) BOOL fullBoard;
@property (nonatomic, readonly, retain) UISwitch *computerMovesFirst;
@property (nonatomic, readonly, retain) UIButton *startButton;
@property (nonatomic, readonly, retain) UIButton *colorButton;
@property (nonatomic, readonly, retain) UIButton *boardButton;
@property (nonatomic, readonly, retain) UIButton *guidelinesButton;

- (IBAction)changeColor:(UIButton *)sender;
- (IBAction)changeBoard:(UIButton *)sender;
- (IBAction)go:(UIButton *)sender;

@end

@implementation CreatePuzzleSetupViewController

@synthesize color = __color, fullBoard = __fullBoard, computerMovesFirst = __computerMovesFirst, startButton = __startButton, colorButton = __colorButton, boardButton = __boardButton, guidelinesButton = __guidelinesButton;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Select Options";
	self.view.backgroundColor = BACKGROUND_COLOR;
	
//	[self.colorButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.startButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.boardButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.guidelinesButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
	
	self.fullBoard = NO;
	self.color = kWhite;
}

- (void)dealloc {
	[__computerMovesFirst release];
	__computerMovesFirst = nil;
	[__startButton release];
	__startButton = nil;
	[__colorButton release];
	__colorButton = nil;
	[__boardButton release];
	__boardButton = nil;
	[__guidelinesButton release];
	__guidelinesButton = nil;
	
	[super dealloc];
}

- (IBAction)changeColor:(UIButton *)sender 
{
	if (self.color == kWhite) {
		[sender setTitle:BLACK_LABEL forState:UIControlStateNormal];
		self.color = kBlack;
	} else {
		[sender setTitle:WHITE_LABEL forState:UIControlStateNormal];
		self.color = kWhite;		
	}
}

- (IBAction)changeBoard:(UIButton *)sender 
{
	if (self.fullBoard) {
		[sender setTitle:EMPTY_BOARD forState:UIControlStateNormal];
		self.fullBoard = NO;
	} else {
		[sender setTitle:FULL_BOARD forState:UIControlStateNormal];
		self.fullBoard = YES;
	}
}

- (IBAction)go:(UIButton *)sender 
{
	CreatePuzzleViewController *vc = [[[CreatePuzzleViewController alloc] init] autorelease];
	vc.fullBoard = self.fullBoard;
	vc.playerColor = self.color;
	vc.computerMoveFirst = self.computerMovesFirst.on;
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)guidelinesButtonPressed:(id)sender
{
	TacticGuidelinesViewController *vc = [[[TacticGuidelinesViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
