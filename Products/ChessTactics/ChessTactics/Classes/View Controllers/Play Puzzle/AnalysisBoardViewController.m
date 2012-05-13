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


@interface AnalysisBoardViewController () <ChessBoardViewControllerDelegate> {
	PuzzleModel *__puzzleModel;
	ChessBoardViewController *__chessBoardViewController;
	BOOL __computerMoveFirst;
	BOOL __piecesSetup;
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;
@property (nonatomic, readwrite, assign) BOOL piecesSetup;

- (IBAction)resetBoard:(id)sender;

@end

@implementation AnalysisBoardViewController

@synthesize puzzleModel = __puzzleModel, chessBoardViewController = __chessBoardViewController, computerMoveFirst = __computerMoveFirst, piecesSetup = __piecesSetup;

#pragma mark - View Life Cycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Analysis Board";
	
	[self setupPuzzle];
}

- (void)dealloc {
	[__puzzleModel release];
	__puzzleModel = nil;
	[__chessBoardViewController release];
	__chessBoardViewController = nil;
	
	[super dealloc];
}

#pragma mark - Private Methods

- (void)setupPuzzle {
	self.piecesSetup = NO;
	NSDictionary *setupData = self.puzzleModel.setupData;
	
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
	
	if (self.computerMoveFirst) {
		if (playerColor == kWhite) {
			self.chessBoardViewController.playerColor = kBlack;
		} else {
			self.chessBoardViewController.playerColor = kWhite;
		}
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
		} else {
			self.chessBoardViewController.playerColor = kWhite;
		}
	}
}

@end
