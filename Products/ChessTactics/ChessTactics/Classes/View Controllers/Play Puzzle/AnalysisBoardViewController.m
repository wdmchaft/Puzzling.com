//
//  AnalysisBoardViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/8/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "AnalysisBoardViewController.h"
#import "ChessBoardViewController.h"
#import "TacticsDataConstants.h"
#import "Coordinate.h"
#import "ConstantsForUI.h"


@interface AnalysisBoardViewController () <ChessBoardViewControllerDelegate> {
	NSDictionary *__setupData;
	ChessBoardViewController *__chessBoardViewController;
	BOOL __computerMoveFirst;
	BOOL __piecesSetup;
	
	IBOutlet UIButton *__resetButton;
	IBOutlet UILabel *__bottomLabel;
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;
@property (nonatomic, readwrite, assign) BOOL piecesSetup;
@property (nonatomic, readwrite, retain) UIButton *resetButton;
@property (nonatomic, readwrite, retain) UILabel *bottomLabel;

- (IBAction)resetBoard:(id)sender;

@end

@implementation AnalysisBoardViewController

@synthesize setupData = __setupData, chessBoardViewController = __chessBoardViewController, computerMoveFirst = __computerMoveFirst, piecesSetup = __piecesSetup, resetButton = __resetButton, bottomLabel = __bottomLabel;

#pragma mark - View Life Cycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Analysis Board";
	self.view.backgroundColor = BACKGROUND_COLOR;
	self.bottomLabel.backgroundColor = [UIColor clearColor];
	
//	[self.resetButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
	
	[self setupPuzzle];
}

- (void)dealloc {
	[__setupData release];
	__setupData = nil;
	[__chessBoardViewController release];
	__chessBoardViewController = nil;
	[__resetButton release];
	__resetButton = nil;
	[__bottomLabel release];
	__bottomLabel = nil;
	
	[super dealloc];
}

#pragma mark - Private Methods

- (void)setupPuzzle {
	self.piecesSetup = NO;
	NSDictionary *setupData = self.setupData;
	
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
	
	NSArray *piecesSetup = [setupData objectForKey:PIECES_SETUP];
	[self.chessBoardViewController setupPieces:piecesSetup];
	[self.chessBoardViewController resetAllPiecesToHaveNotMoved];
	
	if (self.computerMoveFirst) {
		if (playerColor == kWhite) {
			self.chessBoardViewController.playerColor = kBlack;
		} else {
			self.chessBoardViewController.playerColor = kWhite;
		}
	}
	
	if (self.chessBoardViewController.playerColor == kWhite)
	{
		self.bottomLabel.text = @"White to move.";
	}
	else
	{
		self.bottomLabel.text = @"Black to move.";
	}
	
	self.piecesSetup = YES;
}

#pragma mark - Buttons

- (IBAction)resetBoard:(id)sender {
	[self setupPuzzle];
}

#pragma mark - ChessBoard Delegate

- (void)piece:(ChessPiece *)piece didMoveFromX:(int)x Y:(int)y pawnPromoted:(NSString *)aClass {
	if (self.piecesSetup) {
		if (self.chessBoardViewController.playerColor == kWhite) {
			self.chessBoardViewController.playerColor = kBlack;
			self.bottomLabel.text = @"Black to move.";
		} else {
			self.chessBoardViewController.playerColor = kWhite;
			self.bottomLabel.text = @"White to move.";
		}
	}
}

@end
