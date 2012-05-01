//
//  CreatePuzzleViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "CreatePuzzleViewController.h"
#import "ChessBoardViewController.h"
#import "ChessMove.h"
#import "Coordinate.h"


#define EXTRA_PIECE_X 14
#define EXTRA_PIECE_DIFFERENCE 50
#define EXTRA_PIECE_Y 331

#define TYPE @"type"
#define COLOR @"color"
#define PIECES_SETUP @"pieces_setup"
#define X_LOCATION @"x"
#define Y_LOCATION @"y"
#define START_X @"start_x"
#define START_Y @"start_y"
#define FINISH_X @"finish_x"
#define FINISH_Y @"finish_y"
#define MOVES @"moves"

@interface CreatePuzzleViewController () <ChessBoardViewControllerDelegate> {
	ChessBoardViewController *__chessBoardViewController;
	Pawn *__extraPawn;
	Rook *__extraRook;
	King *__extraKing;
	Knight *__extraKnight;
	Bishop *__extraBishop;
	Queen *__extraQueen;
	NSMutableArray *__extraPieces;
	ChessPiece *__pannedPiece;
	UIButton *__undoButton;
	NSMutableArray *__moves;
	NSMutableDictionary *__setup;
	Color __playerColor;
	BOOL __fullBoard;
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;
@property (nonatomic, readwrite, retain) Pawn *extraPawn;
@property (nonatomic, readwrite, retain) Rook *extraRook;
@property (nonatomic, readwrite, retain) King *extraKing;
@property (nonatomic, readwrite, retain) Knight *extraKnight;
@property (nonatomic, readwrite, retain) Bishop *extraBishop;
@property (nonatomic, readwrite, retain) Queen *extraQueen;
@property (nonatomic, readwrite, retain) NSMutableArray *extraPieces;
@property (nonatomic, readwrite, retain) ChessPiece *pannedPiece;
@property (nonatomic, readwrite, retain) NSMutableArray *moves;
@property (nonatomic, readwrite, retain) NSMutableDictionary *setup;

- (void)setupExtraPieces;
- (void)addPiecesToView;
- (void)submitTactic;

@end

@implementation CreatePuzzleViewController

@synthesize chessBoardViewController = __chessBoardViewController, extraKing = __extraKing, extraPawn = __extraPawn, extraRook = __extraRook, extraQueen = __extraQueen, extraBishop = __extraBishop, extraKnight = __extraKnight, extraPieces = __extraPieces, pannedPiece = __pannedPiece, moves = __moves, setup = __setup, playerColor = __playerColor, fullBoard = __fullBoard;

#pragma mark - View Life Cycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Create Tactic";
	
	self.chessBoardViewController = [[[ChessBoardViewController alloc] initWithColor:self.playerColor] autorelease];
	self.chessBoardViewController.inEditingMode = YES;
	self.chessBoardViewController.delegate = self;
	self.chessBoardViewController.fullBoard = self.fullBoard;
	[self.view addSubview:self.chessBoardViewController.view];
	
	UIPanGestureRecognizer *gr = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(boardPanned:)] autorelease];
	[self.view addGestureRecognizer:gr];
	
	[self setupExtraPieces];
}

- (void)dealloc {
	[__chessBoardViewController release];
	__chessBoardViewController = nil;
	[__extraBishop release];
	__extraBishop = nil;
	[__extraKing release];
	__extraKing = nil;
	[__extraKnight release];
	__extraKnight = nil;
	[__extraPawn release];
	__extraPawn = nil;
	[__extraQueen release];
	__extraQueen = nil;
	[__extraRook release];
	__extraRook = nil;
	[__undoButton release];
	__undoButton = nil;
	[__moves release];
	__moves = nil;
	[__setup release];
	__setup = nil;
	
	[super dealloc];
}

#pragma mark - Properties

- (NSMutableArray *)extraPieces {
	if (!__extraPieces) {
		__extraPieces = [[NSMutableArray alloc] initWithCapacity:6];
	}
	return __extraPieces;
}

#pragma mark - Private Methods

- (void)setupExtraPieces {
	self.extraBishop = [[[Bishop alloc] initWithColor:kWhite] autorelease];
	self.extraKing = [[[King alloc] initWithColor:kWhite] autorelease];
	self.extraKnight = [[[Knight alloc] initWithColor:kWhite] autorelease];
	self.extraPawn = [[[Pawn alloc] initWithColor:kWhite] autorelease];
	self.extraQueen = [[[Queen alloc] initWithColor:kWhite] autorelease];
	self.extraRook = [[[Rook alloc] initWithColor:kWhite] autorelease];
	
	[self.extraPieces addObject:self.extraBishop];
	[self.extraPieces addObject:self.extraKing];
	[self.extraPieces addObject:self.extraKnight];
	[self.extraPieces addObject:self.extraPawn];
	[self.extraPieces addObject:self.extraQueen];
	[self.extraPieces addObject:self.extraRook];
	
	[self addPiecesToView];
}

- (void)addPiecesToView {
	self.extraPawn.view.frame = CGRectMake(EXTRA_PIECE_X, EXTRA_PIECE_Y, self.chessBoardViewController.squareSize, self.chessBoardViewController.squareSize);
	self.extraKnight.view.frame = CGRectMake(EXTRA_PIECE_X + EXTRA_PIECE_DIFFERENCE, EXTRA_PIECE_Y, self.chessBoardViewController.squareSize, self.chessBoardViewController.squareSize);
	self.extraBishop.view.frame = CGRectMake(EXTRA_PIECE_X + 2*EXTRA_PIECE_DIFFERENCE, EXTRA_PIECE_Y, self.chessBoardViewController.squareSize, self.chessBoardViewController.squareSize);
	self.extraRook.view.frame = CGRectMake(EXTRA_PIECE_X, EXTRA_PIECE_Y + EXTRA_PIECE_DIFFERENCE, self.chessBoardViewController.squareSize, self.chessBoardViewController.squareSize);
	self.extraKing.view.frame = CGRectMake(EXTRA_PIECE_X + EXTRA_PIECE_DIFFERENCE, EXTRA_PIECE_Y + EXTRA_PIECE_DIFFERENCE, self.chessBoardViewController.squareSize, self.chessBoardViewController.squareSize);
	self.extraQueen.view.frame = CGRectMake(EXTRA_PIECE_X + 2*EXTRA_PIECE_DIFFERENCE, EXTRA_PIECE_Y + EXTRA_PIECE_DIFFERENCE, self.chessBoardViewController.squareSize, self.chessBoardViewController.squareSize);
	
	for (ChessPiece *piece in self.extraPieces) {
		[self.view addSubview:piece.view];
	}
}

- (void)submitTactic {
	NSMutableDictionary *solutionData = [NSMutableDictionary dictionary];
	NSMutableArray *solutionMoves = [NSMutableArray array];
	for (ChessMove *move in self.moves) {
		NSMutableDictionary *info = [NSMutableDictionary dictionary];
		[info setValue:[NSNumber numberWithInt:move.start.x] forKey:START_X];
		[info setValue:[NSNumber numberWithInt:move.start.y] forKey:START_Y];
		[info setValue:[NSNumber numberWithInt:move.finish.x] forKey:FINISH_X];
		[info setValue:[NSNumber numberWithInt:move.finish.y] forKey:FINISH_Y];
		[solutionMoves addObject:info];
	}
	[solutionData setValue:solutionMoves forKey:MOVES];
	
	NSLog(@"%@", self.setup);
	NSLog(@"%@", solutionData);
}

- (void)createSetup {
	self.setup = [NSMutableDictionary dictionary];
	NSMutableArray *piecesSetup = [NSMutableArray array];
	for (ChessPiece *piece in self.chessBoardViewController.allPieces) {
		NSString *color = piece.color==kWhite?@"white":@"black";
		NSString *type = [NSStringFromClass([piece class]) lowercaseString];
		NSDictionary *info = [NSMutableDictionary dictionary];
		[info setValue:color forKey:COLOR];
		[info setValue:type forKey:TYPE];
		[info setValue:[NSNumber numberWithInt:piece.x] forKey:X_LOCATION];
		[info setValue:[NSNumber numberWithInt:piece.y] forKey:Y_LOCATION];
		[piecesSetup addObject:info];
	}
	[self.setup setValue:piecesSetup forKey:PIECES_SETUP];
}

#pragma mark - IBActions

- (IBAction)changePiecesColor:(UIButton *)sender {
	if (self.extraPawn.color == kWhite) {
		for (ChessPiece *piece in self.extraPieces) {
			piece.color = kBlack;
		}
		[sender setTitle:@"Color: Black" forState:UIControlStateNormal]; 
	} else {
		for (ChessPiece *piece in self.extraPieces) {
			piece.color = kWhite;
		}
		[sender setTitle:@"Color: White" forState:UIControlStateNormal]; 
	}
	for (ChessPiece *piece in self.extraPieces) {
		[piece.view removeFromSuperview];
		piece.view = nil;
	}
	[self addPiecesToView];
}

- (IBAction)next:(id)sender {
	if (self.chessBoardViewController.inEditingMode) {
		self.chessBoardViewController.inEditingMode = NO;
		[sender setTitle:@"Submit" forState:UIControlStateNormal];
		[self createSetup];
		self.moves = [NSMutableArray array];
		self.chessBoardViewController.playerColor = self.playerColor;
	} else {
		[self submitTactic];
	}
}

#pragma mark - Gesture Recognizers

- (void)boardPanned:(UIPanGestureRecognizer *)gr {
	if (gr.state == UIGestureRecognizerStateBegan) {
		self.pannedPiece = nil;
		for (ChessPiece *piece in self.extraPieces) {
			if (CGRectContainsPoint(piece.view.frame, [gr locationInView:self.view])) {
				self.pannedPiece = piece;
			}
		}
	} else if (gr.state == UIGestureRecognizerStateChanged) {
		if (self.pannedPiece == nil) {
			return;
		}
		self.pannedPiece.view.frame = CGRectMake([gr locationInView:self.view].x, [gr locationInView:self.view].y, self.pannedPiece.view.frame.size.width, self.pannedPiece.view.frame.size.height);
	} else if (gr.state == UIGestureRecognizerStateEnded) {
		if (self.pannedPiece == nil) {
			return;
		}
		if (CGRectContainsPoint(self.chessBoardViewController.view.frame, [gr locationInView:self.view])) {
			[self.chessBoardViewController addPiece:[self.pannedPiece class] withColor:self.pannedPiece.color toLocation:[gr locationInView:self.chessBoardViewController.view]];
		}
		[self addPiecesToView]; //put view back where it belongs
		self.pannedPiece = nil;
	}
}

#pragma mark - ChessBoardViewController Delegate Methods

- (void)piece:(ChessPiece *)piece willMoveToX:(int)x Y:(int)y {
	if (!self.chessBoardViewController.inEditingMode) {
		ChessMove *model = [[[ChessMove alloc] init] autorelease];
		model.start = [[[Coordinate alloc] initWithX:piece.x Y:piece.y] autorelease];
		model.finish = [[[Coordinate alloc] initWithX:x Y:y] autorelease];
		[self.moves addObject:model];
		if (self.chessBoardViewController.playerColor == kWhite) {
			self.chessBoardViewController.playerColor = kBlack;
		} else {
			self.chessBoardViewController.playerColor = kWhite;
		}
	}
}

@end