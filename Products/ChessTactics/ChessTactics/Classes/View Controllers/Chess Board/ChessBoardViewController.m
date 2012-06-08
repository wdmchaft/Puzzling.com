//
//  ChessBoardViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "ChessBoardViewController.h"
#import "ChessBoardView.h"
#import "ChessModel.h"
#import "Coordinate.h"
#import "ChessModel.h"
#import "TacticsDataConstants.h"


#define SECONDS_PER_SQUARE .05

@interface ChessBoardViewController () <ChessModelDelegate, UIActionSheetDelegate> {
	Color __playerColor;
	BOOL __interactionAllowed;
	ChessPiece *__selectedPiece;
	ChessPiece *__pannedPiece;
	ChessModel *__chessModel;
	NSMutableArray *__highlightSquares;
	NSMutableArray *__recentMoveSquares;
	BOOL __inEditingMode;
	id<ChessBoardViewControllerDelegate> __delegate;
	BOOL __fullBoard;
	BOOL __promotionInProgress;
	ChessPiece *__promotedPiece;
	Coordinate *__startPromotionCoord;
	BOOL __shouldRotatePieces;
	NSString *__promotionType;
}

@property (nonatomic, readwrite, retain) ChessPiece *selectedPiece;
@property (nonatomic, readwrite, retain) ChessPiece *pannedPiece;
@property (nonatomic, readwrite, retain) ChessModel *chessModel;
@property (nonatomic, readwrite, retain) NSMutableArray *highlightSquares;
@property (nonatomic, readwrite, retain) NSMutableArray *recentMoveSquares;
@property (nonatomic, readwrite, assign) BOOL promotionInProgress;
@property (nonatomic, readwrite, retain) ChessPiece *promotedPiece;
@property (nonatomic, readwrite, retain) Coordinate *startPromotionCoord;
@property (nonatomic, readwrite, assign) BOOL shouldRotatePieces;
@property (nonatomic, readwrite, retain) NSString *promotionType;

- (int)squareSize;
- (void)movePiece:(ChessPiece*)piece to:(Coordinate*)finish;
- (NSTimeInterval)timeForMoveFrom:(Coordinate*)start to:(Coordinate*)finish;
- (void)boardPanned:(UIPanGestureRecognizer *)gr;
- (void)boardTapped:(UITapGestureRecognizer*)tapGesture;
- (void)setUpBoard;
- (void)promotePieceToClass:(NSString *)type;

@end

@implementation ChessBoardViewController

@synthesize playerColor = __playerColor, interactionAllowed = __interactionAllowed, selectedPiece = __selectedPiece, chessModel = __chessModel, highlightSquares = __highlightSquares, inEditingMode = __inEditingMode, pannedPiece = __pannedPiece, delegate = __delegate, fullBoard = __fullBoard, recentMoveSquares = __recentMoveSquares, promotedPiece = __promotedPiece, promotionInProgress = __promotionInProgress, startPromotionCoord = __startPromotionCoord, shouldRotatePieces = __shouldRotatePieces, promotionType = __promotionType;

- (id)initWithColor:(Color)newColor {
	self = [self init];
	if (self) {
		self.playerColor = newColor;
		if (newColor == kBlack) {
			self.shouldRotatePieces = YES;
		} else {
			self.shouldRotatePieces = NO;
		}
		self.fullBoard = YES; //default
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view = [[[ChessBoardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.width)] autorelease];
	self.chessModel = [[[ChessModel alloc] init] autorelease];
	self.chessModel.delegate = self;
	
	//Add 1-8, a-h labels
	for (int i = 0; i<8; i++) {
		int y = i * self.squareSize;
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, y, 12, 12)] autorelease];
		label.text = [NSString stringWithFormat:@"%d", 8-i];
		if (self.shouldRotatePieces) {
			label.transform = CGAffineTransformMakeRotation(M_PI);
		}
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:11];
		label.textColor = [UIColor darkGrayColor];
		[self.view addSubview:label];
	}
	for (int i = 0; i<8; i++) {
		int x = i * self.squareSize + self.squareSize - 10;
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(x, 8*self.squareSize-12, 10, 12)] autorelease];
		label.text = [NSString stringWithFormat:@"%c", 'a'+i];
		if (self.shouldRotatePieces) {
			label.transform = CGAffineTransformMakeRotation(M_PI);
		}
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:11];
		label.textColor = [UIColor darkGrayColor];
		[self.view addSubview:label];
	}
	
	UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boardTapped:)];
	[self.view addGestureRecognizer:tapGR];
	[tapGR release];
	//Add drag guesture
	UIPanGestureRecognizer *gr = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(boardPanned:)] autorelease];
	[self.view addGestureRecognizer:gr];
	
	[self setUpBoard];
	self.interactionAllowed = YES;
}

- (void)dealloc {
	[__selectedPiece release];
	__selectedPiece = nil;
	[__chessModel release];
	__chessModel = nil;
	[__highlightSquares release];
	__highlightSquares = nil;
	[__pannedPiece release];
	__pannedPiece = nil;
	__delegate = nil;
	[__recentMoveSquares release];
	__recentMoveSquares = nil;
	[__promotedPiece release];
	__promotedPiece = nil;
	[__startPromotionCoord release];
	__startPromotionCoord = nil;
	[__promotionType release];
	__promotionType = nil;
	
	[super dealloc];
}

#pragma mark - Properties

- (NSMutableArray *)highlightSquares {
	if (!__highlightSquares) {
		__highlightSquares = [[NSMutableArray alloc] init];
	}
	return __highlightSquares;
}

- (NSMutableArray *)recentMoveSquares {
	if (!__recentMoveSquares) {
		__recentMoveSquares = [[NSMutableArray arrayWithCapacity:2] retain];
	}
	return __recentMoveSquares;
}

- (NSArray *)allPieces {
	NSMutableArray *allPieces = [NSMutableArray array];
	for (int x = 0; x<8; x++) {
		for (int y = 0; y<8; y++) {
			ChessPiece *piece = [self.chessModel getPieceAtX:x Y:y];
			if (piece != nil) {
				[allPieces addObject:piece];
			}
		}
	}
	return allPieces;
}

- (void)setPlayerColor:(Color)playerColor {
	__playerColor = playerColor;
}

#pragma mark - Public Methods

- (void)setupPieces:(NSArray *)pieces {
	for (NSDictionary *pieceSetupData in pieces) {
		Color color = [[pieceSetupData objectForKey:COLOR] isEqualToString:WHITE]?kWhite:kBlack;
		Class pieceClass = NSClassFromString([pieceSetupData objectForKey:TYPE]);
		int x = [[pieceSetupData objectForKey:X_LOCATION] intValue];
		int y = [[pieceSetupData objectForKey:Y_LOCATION] intValue];
		[self addPiece:pieceClass withColor:color toCoordinate:[[[Coordinate alloc] initWithX:x Y:y] autorelease]];
	}
}

- (int)squareSize {
	return self.view.bounds.size.width/8;
}

- (void)addPiece:(Class)ChessPieceType withColor:(Color)color toCoordinate:(Coordinate *)coord {
	[self addPiece:ChessPieceType withColor:color toLocation:CGPointMake(coord.x*self.squareSize, (8-coord.y) * self.squareSize-1)];
}

- (void)addPiece:(Class)ChessPieceType withColor:(Color)color toLocation:(CGPoint)loc {
	if (!CGRectContainsPoint(self.view.frame, loc)) {
		return;
	}
	int x = loc.x/self.squareSize;
	int y = 8 - loc.y/self.squareSize;
	ChessPiece *piece = [[((ChessPiece *)[ChessPieceType alloc]) initWithColor:color] autorelease];
	piece.x = x;
	piece.y = y;
	
	if (self.shouldRotatePieces) {
		piece.view.transform = CGAffineTransformMakeRotation(M_PI);
	}
	[self.view addSubview:piece.view];
	[self movePiece:piece to:[[[Coordinate alloc] initWithX:x Y:y] autorelease]];
	
	//Remove the squares set when moved
	for (UIView *view in self.recentMoveSquares) {
		[view removeFromSuperview];
	}
	[self.recentMoveSquares removeAllObjects];
}

- (void)movePieceFromX:(int)startX Y:(int)startY toX:(int)finishX Y:(int)finishY promotion:(NSString *)promotionType {
	self.promotionType = promotionType;
	ChessPiece *piece = [self.chessModel getPieceAtX:startX Y:startY];
	[self movePiece:piece to:[[[Coordinate alloc] initWithX:finishX Y:finishY] autorelease]];
}

- (void)resetAllPiecesToHaveNotMoved {
	for (int x = 0; x<8; x++) {
		for (int y = 0; y<8; y++) {
			ChessPiece *piece = [self.chessModel getPieceAtX:x Y:y];
			if ([piece isKindOfClass:[Pawn class]])
			{
				((Pawn *)piece).enPassentEnabledLeft = NO;
				((Pawn *)piece).enPassentEnabledRight = NO;
				if (piece.color == kWhite)
				{
					if (piece.y == 1)
					{
						piece.moved = NO;
					}
					else
					{
						piece.moved = YES;
					}
				}
				else
				{
					if (piece.y == 6)
					{
						piece.moved = NO;
					}
					else
					{
						piece.moved = YES;
					}
				}
			}
			else
			{
				piece.moved = YES;
			}
		}
	}
}

#pragma mark - Private Methods

- (void)movePiece:(ChessPiece*)piece to:(Coordinate*)finish {
	[UIView beginAnimations:nil context:NULL];
	double timeForMove = [self timeForMoveFrom:[[[Coordinate alloc] initWithX:piece.x Y:piece.y] autorelease] to:finish];
	[UIView setAnimationDuration:timeForMove];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	piece.view.frame = CGRectMake(finish.x*self.squareSize, (7-finish.y)*self.squareSize, self.squareSize, self.squareSize);
	[UIView commitAnimations];
	self.interactionAllowed = NO;
	[self performSelector:@selector(setInteractionAllowed:) withObject:[NSNumber numberWithBool:YES] afterDelay:timeForMove];
	
	int startX = piece.x;
	int startY = piece.y;
	
	for (UIView *view in self.recentMoveSquares) {
		[view removeFromSuperview];
	}
	[self.recentMoveSquares removeAllObjects];
	
	UIImageView * highlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"previousSquareHighlight"]];
	highlight.frame = CGRectMake(startX*self.squareSize, (7-startY)*self.squareSize, self.squareSize, self.squareSize);
	[self.view addSubview:highlight];
	[self.recentMoveSquares addObject:highlight];
	[highlight release];
	highlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"previousSquareHighlight"]];
	highlight.frame = CGRectMake(finish.x*self.squareSize, (7-finish.y)*self.squareSize, self.squareSize, self.squareSize);
	[self.view addSubview:highlight];
	[self.recentMoveSquares addObject:highlight];
	[highlight release];
	
	self.startPromotionCoord = [[[Coordinate alloc] initWithX:startX Y:startY] autorelease]; //if necessicary
	
	[self.chessModel movePiece:piece toX:finish.x Y:finish.y withDelay:[self timeForMoveFrom:[[[Coordinate alloc] initWithX:piece.x Y:piece.y] autorelease] to:[[[Coordinate alloc] initWithX:finish.x Y:finish.y] autorelease]]];
	
	if (!self.promotionInProgress && [self.delegate respondsToSelector:@selector(piece:didMoveFromX:Y:pawnPromoted:)]) {
		[self.delegate piece:piece didMoveFromX:startX Y:startY pawnPromoted:nil];
	}
}

- (NSTimeInterval)timeForMoveFrom:(Coordinate*)start to:(Coordinate*)finish {
	double distance = sqrt(pow((start.x-finish.x), 2) + pow((start.y-finish.y), 2));
	return distance * SECONDS_PER_SQUARE;
}

#pragma mark - TapGesture

- (void)boardTapped:(UITapGestureRecognizer*)tapGesture {
	if (!self.interactionAllowed || self.inEditingMode) {
		return;
	}
	
	int x = [tapGesture locationInView:self.view].x/self.squareSize;
	int y = 8-[tapGesture locationInView:self.view].y/self.squareSize;
	if (self.selectedPiece) {
		BOOL legalMove = NO;
		for (Coordinate * coord in [self.chessModel getLegalMovesForPiece:self.selectedPiece]) {
			if (coord.x == x && coord.y == y) {
				legalMove = YES;
				break;
			}
		}
		if (legalMove) {
			if ([self.selectedPiece isKindOfClass:[King class]] && abs(self.selectedPiece.x - x) == 2) { //castling
				if (x == 2) {
					ChessPiece * rook = [self.chessModel getPieceAtX:0 Y:self.selectedPiece.y];
					if (rook) {
						[self movePiece:rook to:[[[Coordinate alloc] initWithX:3 Y:self.selectedPiece.y] autorelease]];
					}
				} else if (x == 6) {
					ChessPiece * rook = [self.chessModel getPieceAtX:7 Y:self.selectedPiece.y];
					if (rook) {
						[self movePiece:rook to:[[[Coordinate alloc] initWithX:5 Y:self.selectedPiece.y] autorelease]];
					}
				}
			}
			//Move piece
			[self movePiece:self.selectedPiece to:[[[Coordinate alloc] initWithX:x Y:y] autorelease]];
		}
		
		for (UIView * highlightView in [self.highlightSquares reverseObjectEnumerator]) {
			[highlightView removeFromSuperview];
			[self.highlightSquares removeObject:highlightView];
		}
		[self.highlightSquares removeAllObjects]; //just in case
		ChessPiece * selectedPieceTemp = self.selectedPiece;
		self.selectedPiece = nil;
		if ([self.chessModel getPieceAtX:x Y:y] && [self.chessModel getPieceAtX:x Y:y].color == selectedPieceTemp.color) {
			[self boardTapped:tapGesture]; //Do this again with a different piece
		}
	} else {
		self.selectedPiece = [self.chessModel getPieceAtX:x Y:y];
		
		if (self.selectedPiece.color != self.playerColor) { //do nothing
			self.selectedPiece = nil;
			return;
		}
		
		for (Coordinate * coord in [self.chessModel getLegalMovesForPiece:self.selectedPiece]) {
			UIImageView * highlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"squareHighlight"]];
			highlight.frame = CGRectMake(coord.x*self.squareSize, (7-coord.y)*self.squareSize, self.squareSize, self.squareSize);
			[self.view addSubview:highlight];
			[self.highlightSquares addObject:highlight];
			[highlight release];
		}
	}
}

- (void)boardPanned:(UIPanGestureRecognizer *)gr {
	if (!self.interactionAllowed) {
		return;
	}
	
	int x = [gr locationInView:self.view].x/self.squareSize;
	int y = 8-[gr locationInView:self.view].y/self.squareSize;
	
	if (gr.state == UIGestureRecognizerStateBegan) {
		ChessPiece *piece = [self.chessModel getPieceAtX:x Y:y];
		if (piece == nil || (self.playerColor != piece.color && !self.inEditingMode)) {
			return;
		}
		self.pannedPiece = piece;
		self.pannedPiece.view.frame = CGRectMake([gr locationInView:self.view].x, [gr locationInView:self.view].y, self.pannedPiece.view.frame.size.width, self.pannedPiece.view.frame.size.height);
	} else if (gr.state == UIGestureRecognizerStateChanged) {
		if (self.pannedPiece == nil) {
			return;
		}
		self.pannedPiece.view.frame = CGRectMake([gr locationInView:self.view].x - self.pannedPiece.view.frame.size.width/2, [gr locationInView:self.view].y - self.pannedPiece.view.frame.size.height, self.pannedPiece.view.frame.size.width, self.pannedPiece.view.frame.size.height);
		
		//highlight square
		for (UIView *view in self.highlightSquares) {
			[view removeFromSuperview];
		}
		[self.highlightSquares removeAllObjects];
		UIImageView * highlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"editingSquareHighlight"]];
		highlight.frame = CGRectMake(x*self.squareSize, (7-y)*self.squareSize, self.squareSize, self.squareSize);
		[self.view addSubview:highlight];
		[self.highlightSquares addObject:highlight];
		[highlight release];
	} else if (gr.state == UIGestureRecognizerStateEnded) {
		if (self.pannedPiece == nil) {
			return;
		}
		if (self.inEditingMode) {
			if (CGRectContainsPoint(self.view.frame, [gr locationInView:self.view])) {
				int x = [gr locationInView:self.view].x/self.squareSize;
				int y = 8-[gr locationInView:self.view].y/self.squareSize;
				[self movePiece:self.pannedPiece to:[[[Coordinate alloc] initWithX:x Y:y] autorelease]];
			} else { //remove piece
				[self.chessModel removePiece:self.pannedPiece];
				[self.pannedPiece.view removeFromSuperview];
			}
		} else { //move the piece
			BOOL legalMove = NO;
			for (Coordinate * coord in [self.chessModel getLegalMovesForPiece:self.pannedPiece]) {
				if (coord.x == x && coord.y == y) {
					legalMove = YES;
					break;
				}
			}
			if (legalMove) {
				if ([self.pannedPiece isKindOfClass:[King class]] && abs(self.pannedPiece.x - x) == 2) { //castling
					if (x == 2) {
						ChessPiece * rook = [self.chessModel getPieceAtX:0 Y:self.pannedPiece.y];
						if (rook) {
							[self movePiece:rook to:[[[Coordinate alloc] initWithX:3 Y:self.pannedPiece.y] autorelease]];
						}
					} else if (x == 6) {
						ChessPiece * rook = [self.chessModel getPieceAtX:7 Y:self.pannedPiece.y];
						if (rook) {
							[self movePiece:rook to:[[[Coordinate alloc] initWithX:5 Y:self.pannedPiece.y] autorelease]];
						}
					}
				}
				//Move piece
				[self movePiece:self.pannedPiece to:[[[Coordinate alloc] initWithX:x Y:y] autorelease]];
			} else { //move it back to where it was
				self.pannedPiece.view.frame = CGRectMake(self.pannedPiece.x*self.squareSize, (7-self.pannedPiece.y)*self.squareSize, self.squareSize, self.squareSize);
			}
		}
		self.pannedPiece = nil;
		
		//Unhighlight all the squares
		for (UIView *view in self.highlightSquares) {
			[view removeFromSuperview];
		}
		[self.highlightSquares removeAllObjects];
	}
}

- (void)setUpBoard {
	if (self.shouldRotatePieces){
		self.view.transform = CGAffineTransformMakeRotation(M_PI);
	}
	
	if (self.fullBoard) { //otherwise, leave it empty
		[self.chessModel setUpBoard];
	}
	
	//Add piece views
	for (int x = 0; x<8; x++) {
		for (int y = 0; y<8; y++) {
			UIView * pieceView = [self.chessModel getPieceAtX:x Y:y].view;
			pieceView.frame = CGRectMake(x*self.squareSize, 7*self.squareSize-y*self.squareSize, self.squareSize, self.squareSize);
			if (self.shouldRotatePieces) {
				pieceView.transform = CGAffineTransformMakeRotation(M_PI);
			}
			[self.view addSubview:pieceView];
		}
	}
}

- (void)promotePieceToClass:(NSString *)type {
	self.promotionInProgress = NO;
	if (self.promotedPiece == nil) {
		return;
	}
	
	ChessPiece *piece = nil;
	if ([type isEqualToString:@"Queen"]) {
		piece = [[[Queen alloc] initWithColor:self.promotedPiece.color] autorelease];		
	} else if ([type isEqualToString:@"Bishop"]) {
		piece = [[[Bishop alloc] initWithColor:self.promotedPiece.color] autorelease];		
	} else if ([type isEqualToString:@"Knight"]) {
		piece = [[[Knight alloc] initWithColor:self.promotedPiece.color] autorelease];		
	} else if ([type isEqualToString:@"Rook"]) {
		piece = [[[Rook alloc] initWithColor:self.promotedPiece.color] autorelease];		
	}
	piece.x = self.promotedPiece.x;
	piece.y = self.promotedPiece.y;
	[self.chessModel movePiece:piece toX:piece.x Y:piece.y withDelay:0];
	[self.promotedPiece.view removeFromSuperview];
	piece.view.frame = self.promotedPiece.view.frame;
	if (self.shouldRotatePieces) {
		piece.view.transform = CGAffineTransformMakeRotation(M_PI);
	}
	[self.view addSubview:piece.view];
	
	self.promotedPiece = nil;
	
	if ([self.delegate respondsToSelector:@selector(piece:didMoveFromX:Y:pawnPromoted:)]) {
		[self.delegate piece:piece didMoveFromX:self.startPromotionCoord.x Y:self.startPromotionCoord.y pawnPromoted:NSStringFromClass([piece class])];
	}
}

#pragma mark - Chess Model Delegate

- (void)pawnPromotedToQueen:(ChessPiece *)pawn {
	self.promotedPiece = pawn;
	self.promotionInProgress = YES;
	if (self.promotionType) {
		[self promotePieceToClass:self.promotionType];
	} else {
		[[[[UIActionSheet alloc] initWithTitle:@"Choose Promotion Piece" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Queen", @"Rook", @"Bishop", @"Knight", nil] autorelease] showInView:self.view.superview]; //this is a little hacky
	}
}

- (void)pieceRemoved:(ChessPiece *)piece {
	[piece.view removeFromSuperview];
}

#pragma mark - UIAlertView Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self promotePieceToClass:[actionSheet buttonTitleAtIndex:buttonIndex]];
}

@end
