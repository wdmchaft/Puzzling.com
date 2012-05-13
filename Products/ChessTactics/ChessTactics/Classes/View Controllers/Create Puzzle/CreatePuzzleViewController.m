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
#import "PuzzleSDK.h"
#import "TacticsDataConstants.h"


#define EXTRA_PIECE_X 14
#define EXTRA_PIECE_DIFFERENCE 50
#define EXTRA_PIECE_Y 331

@interface CreatePuzzleViewController () <ChessBoardViewControllerDelegate, UIAlertViewDelegate> {
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
	BOOL __computerMoveFirst;
	BOOL __tacticSubmitted;
	
	IBOutlet UILabel *__moveEnteringLabel;
	IBOutlet UIActivityIndicatorView *__activityView;
	IBOutlet UIButton *__backToPlacePiecesButton;
	IBOutlet UIButton *__nextButton;
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
@property (nonatomic, readwrite, assign) BOOL tacticSubmitted;

//IBOutlets
@property (nonatomic, readwrite, retain) UILabel *moveEnteringLabel;
@property (nonatomic, readwrite, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, readwrite, retain) UIButton *nextButton;
@property (nonatomic, readwrite, retain) UIButton *backToPlacePiecesButton;

- (void)setupExtraPieces;
- (void)addPiecesToView;
- (void)submitTactic;
- (void)setHelpMessageForLastPlayerColor:(Color)color;

@end

@implementation CreatePuzzleViewController

@synthesize chessBoardViewController = __chessBoardViewController, extraKing = __extraKing, extraPawn = __extraPawn, extraRook = __extraRook, extraQueen = __extraQueen, extraBishop = __extraBishop, extraKnight = __extraKnight, extraPieces = __extraPieces, pannedPiece = __pannedPiece, moves = __moves, setup = __setup, playerColor = __playerColor, fullBoard = __fullBoard, moveEnteringLabel = __moveEnteringLabel, computerMoveFirst = __computerMoveFirst, activityView = __activityView, tacticSubmitted = __tacticSubmitted, backToPlacePiecesButton = __backToPlacePiecesButton, nextButton = __nextButton;

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
	[__moveEnteringLabel release];
	__moveEnteringLabel = nil;
	[__backToPlacePiecesButton release];
	__backToPlacePiecesButton = nil;
	[__nextButton release];
	__nextButton = nil;
	
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

- (BOOL)movesContainsPlayerMove {
	if (self.computerMoveFirst) {
		return [self.moves count] >= 2;
	} else {
		return [self.moves count] >= 1;
	}
}

- (void)submitTactic {
	if (self.chessBoardViewController.playerColor == self.playerColor) {//still need to input computer move
		[[[[UIAlertView alloc] initWithTitle:@"Error" message:@"The last move must be a user move. Please enter one more move" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	} else if (![self movesContainsPlayerMove]) {
		[[[[UIAlertView alloc] initWithTitle:@"Error" message:@"There must be at least one user move. Please enter another move." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSMutableDictionary *solutionData = [NSMutableDictionary dictionary];
	NSMutableArray *solutionMoves = [NSMutableArray array];
	for (ChessMove *move in self.moves) {
		NSMutableDictionary *info = [NSMutableDictionary dictionary];
		[info setValue:[NSNumber numberWithInt:move.start.x] forKey:START_X];
		[info setValue:[NSNumber numberWithInt:move.start.y] forKey:START_Y];
		[info setValue:[NSNumber numberWithInt:move.finish.x] forKey:FINISH_X];
		[info setValue:[NSNumber numberWithInt:move.finish.y] forKey:FINISH_Y];
		if (move.promotionType != nil) {
			[info setValue:move.promotionType forKey:PROMOTION_TYPE];
		}
		[solutionMoves addObject:info];
	}
	[solutionData setValue:solutionMoves forKey:MOVES];
	
	self.activityView.hidden = NO;
	[self.view bringSubviewToFront:self.activityView];
	[self.activityView startAnimating];
	self.view.userInteractionEnabled = NO;
	
	[[PuzzleSDK sharedInstance] createPuzzleWithType:@"tactic" setupData:self.setup solutionData:solutionData onCompletionBlock:^(PuzzleAPIResponse status, id data) {
		self.activityView.hidden = YES;
		[self.activityView stopAnimating];
		self.view.userInteractionEnabled = YES;
		if (status == PuzzleOperationSuccessful) {
			self.tacticSubmitted = YES;
			[[[[UIAlertView alloc] initWithTitle:@"Success" message:@"The tactic was successfully created." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		} else {
			NSLog(@"aww crap");
		}
	}];
}

- (BOOL)createSetup { //does some basic checking
	self.setup = [NSMutableDictionary dictionary];
	NSMutableArray *piecesSetup = [NSMutableArray array];
	
	int blackKingCount = 0;
	int whiteKingCount = 0;
	
	for (ChessPiece *piece in self.chessBoardViewController.allPieces) {
		//Checking
		if ([piece isKindOfClass:[King class]]) {
			if (piece.color == kWhite) {
				whiteKingCount++;
			} else {
				blackKingCount++;
			}
		}
		
		NSString *color = piece.color==kWhite?WHITE:BLACK;
		NSString *type = NSStringFromClass([piece class]);
		NSDictionary *info = [NSMutableDictionary dictionary];
		[info setValue:color forKey:COLOR];
		[info setValue:type forKey:TYPE];
		[info setValue:[NSNumber numberWithInt:piece.x] forKey:X_LOCATION];
		[info setValue:[NSNumber numberWithInt:piece.y] forKey:Y_LOCATION];
		[piecesSetup addObject:info];
	}
	[self.setup setValue:piecesSetup forKey:PIECES_SETUP];
	
	[self.setup setValue:self.playerColor==kWhite?WHITE:BLACK forKey:PLAYER_COLOR];
	[self.setup setValue:[NSNumber numberWithBool:self.computerMoveFirst] forKey:COMPUTER_MOVE_FIRST];
	
	return blackKingCount == 1 && whiteKingCount == 1;
}

- (void)setHelpMessageForLastPlayerColor:(Color)color {
	NSString *helpMessage = [NSString stringWithFormat:@"Play %@ move (%@).", color==self.playerColor?@"computer":@"user", color==kWhite?@"Black":@"White"];
	self.moveEnteringLabel.text = helpMessage;
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
		if ([self createSetup]) {
			self.chessBoardViewController.inEditingMode = NO;
			[self.nextButton setTitle:@"Submit" forState:UIControlStateNormal];
			self.moves = [NSMutableArray array];
			
			//hide editing pieces
			for (ChessPiece *piece in self.extraPieces) {
				piece.view.hidden = YES;
			}
			
			self.moveEnteringLabel.hidden = NO;
			self.backToPlacePiecesButton.hidden = NO;
			
			if (self.computerMoveFirst) {
				[self setHelpMessageForLastPlayerColor:self.playerColor];
				if (self.playerColor == kWhite) {
					self.chessBoardViewController.playerColor = kBlack;
				} else {
					self.chessBoardViewController.playerColor = kWhite;
				}
			} else {
				self.chessBoardViewController.playerColor = self.playerColor;
				if (self.playerColor == kWhite) {
					[self setHelpMessageForLastPlayerColor:kBlack];
				} else {
					[self setHelpMessageForLastPlayerColor:kWhite];
				}
			}
		} else {
			[[[[UIAlertView alloc] initWithTitle:@"Malformed tactic" message:@"Check that there is exactly one king for both white and black." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}
	} else {
		[self submitTactic];
	}
}

- (IBAction)backToSetup:(id)sender {
	self.chessBoardViewController = [[[ChessBoardViewController alloc] initWithColor:self.playerColor] autorelease];
	self.chessBoardViewController.inEditingMode = YES;
	self.chessBoardViewController.delegate = self;
	self.chessBoardViewController.fullBoard = NO;
	[self.view addSubview:self.chessBoardViewController.view];
	
	[self.chessBoardViewController setupPieces:[self.setup objectForKey:PIECES_SETUP]];
	
	self.moveEnteringLabel.hidden = YES;
	self.backToPlacePiecesButton.hidden = YES;
	[self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
	
	//show editing pieces
	for (ChessPiece *piece in self.extraPieces) {
		piece.view.hidden = NO;
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
		self.pannedPiece.view.frame = CGRectMake([gr locationInView:self.view].x - self.pannedPiece.view.frame.size.width/2, [gr locationInView:self.view].y - self.pannedPiece.view.frame.size.height, self.pannedPiece.view.frame.size.width, self.pannedPiece.view.frame.size.height);
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

- (void)piece:(ChessPiece *)piece didMoveFromX:(int)x Y:(int)y pawnPromoted:(NSString *)aClass {
	if (!self.chessBoardViewController.inEditingMode) {
		ChessMove *model = [[[ChessMove alloc] init] autorelease];
		model.start = [[[Coordinate alloc] initWithX:x Y:y] autorelease];
		model.finish = [[[Coordinate alloc] initWithX:piece.x Y:piece.y] autorelease];
		model.promotionType = aClass;
		[self.moves addObject:model];
		
		[self setHelpMessageForLastPlayerColor:piece.color];
		if (piece.color == kWhite) {
			self.chessBoardViewController.playerColor = kBlack;
		} else {
			self.chessBoardViewController.playerColor = kWhite;
		}
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (self.tacticSubmitted) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end
