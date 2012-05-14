//
//  ChessModel.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "ChessModel.h"
#import "ChessPieces.h"
#import "Coordinate.h"


@interface ChessModel() {
	NSMutableArray *__board;
	id<ChessModelDelegate> __delegate;
}

@property (nonatomic, readonly, retain) NSMutableArray * board;

- (void)setPiece:(ChessPiece*)piece atX:(int)x Y:(int)y;
- (void)finishPieceMovement:(ChessPiece*)piece withDelay:(NSTimeInterval)seconds;

@end

@implementation ChessModel

@synthesize board = __board;
@synthesize delegate = __delegate;

- (void)dealloc {
	[__board release];
	__board = nil;
	__delegate = nil;
	[super dealloc];
}

#pragma mark - Properties

- (NSMutableArray *)board {
	if (!__board) {
		__board = [[NSMutableArray alloc] initWithCapacity:8];
		for (int i = 0; i<8; i++) {
			NSMutableArray *temp = [NSMutableArray arrayWithCapacity:8];
			for (int i = 0; i<8; i++) {
				[temp addObject:[NSNull null]];
			}
			[__board addObject:temp];
		}
	}
	return __board;
}

#pragma mark - Public Methods

- (void)setUpBoard {
	//Pawns
	for (int i = 0; i<8; i++) {
		ChessPiece * piece = [[Pawn alloc] initWithColor:kWhite];
		[self setPiece:piece atX:i Y:1];
		[piece release];
		
		piece = [[Pawn alloc] initWithColor:kBlack];
		[self setPiece:piece atX:i Y:6];
		[piece release];
	}
	//Rooks
	[self setPiece:[[[Rook alloc] initWithColor:kWhite] autorelease] atX:0 Y:0];
	[self setPiece:[[[Rook alloc] initWithColor:kWhite] autorelease] atX:7 Y:0];
	[self setPiece:[[[Rook alloc] initWithColor:kBlack] autorelease] atX:0 Y:7];
	[self setPiece:[[[Rook alloc] initWithColor:kBlack] autorelease] atX:7 Y:7];
	
	//Bishops
	[self setPiece:[[[Bishop alloc] initWithColor:kWhite] autorelease] atX:2 Y:0];
	[self setPiece:[[[Bishop alloc] initWithColor:kWhite] autorelease] atX:5 Y:0];
	[self setPiece:[[[Bishop alloc] initWithColor:kBlack] autorelease] atX:2 Y:7];
	[self setPiece:[[[Bishop alloc] initWithColor:kBlack] autorelease] atX:5 Y:7];
	
	//Knights
	[self setPiece:[[[Knight alloc] initWithColor:kWhite] autorelease] atX:1 Y:0];
	[self setPiece:[[[Knight alloc] initWithColor:kWhite] autorelease] atX:6 Y:0];
	[self setPiece:[[[Knight alloc] initWithColor:kBlack] autorelease] atX:1 Y:7];
	[self setPiece:[[[Knight alloc] initWithColor:kBlack] autorelease] atX:6 Y:7];
	
	//Queens
	[self setPiece:[[[Queen alloc] initWithColor:kWhite] autorelease] atX:3 Y:0];
	[self setPiece:[[[Queen alloc] initWithColor:kBlack] autorelease] atX:3 Y:7];
	
	//Kings
	[self setPiece:[[[King alloc] initWithColor:kWhite] autorelease] atX:4 Y:0];
	[self setPiece:[[[King alloc] initWithColor:kBlack] autorelease] atX:4 Y:7];
	
}

- (ChessPiece*)getPieceAtX:(int)x Y:(int)y {
	if (x<0 || x>7 || y >7 || y<0) {
		NSLog(@"Get piece out of range");
		return nil;
	}
	if ([[[self.board objectAtIndex:x] objectAtIndex:y] isKindOfClass:[NSNull class]]) {
		return nil;
	}
	return [[self.board objectAtIndex:x] objectAtIndex:y];
}

- (NSArray*)getLegalMovesForPiece:(ChessPiece*)piece {
	NSMutableArray * temp = [NSMutableArray array];
	for (Coordinate * vector in piece.movementVectors.vectors) {
		Coordinate * current = [[Coordinate alloc] initWithX:piece.x Y:piece.y];
		do {
			current.x += vector.x;
			current.y += vector.y;
			if (current.x > 7 || current.x <0 || current.y >7 || current.y<0) {
				break;
			}
			ChessPiece * pieceAtSquare = [self getPieceAtX:current.x Y:current.y];
			if (pieceAtSquare && pieceAtSquare.color == piece.color) {
				break;//Cannot take own piece so stop
			}
			[temp addObject:[[[Coordinate alloc] initWithX:current.x Y:current.y] autorelease]];
			if (pieceAtSquare) {
				break; //don't go further. Hit another piece
			}
		} while (piece.movementVectors.infiniteMovement);
		[current release];
	}
	
	//Pawns
	if ([piece isKindOfClass:[Pawn class]]) {
		if (!((Pawn*)piece).promoted) {
			Coordinate * current = [[Coordinate alloc] initWithX:piece.x Y:piece.y];
			int direction = piece.color==kWhite?1:-1;
			if (![self getPieceAtX:current.x Y:current.y+direction]) {
				[temp addObject:[[[Coordinate alloc] initWithX:current.x Y:current.y+direction] autorelease]];
				if (!piece.moved) {
					if (![self getPieceAtX:current.x Y:current.y+2*direction]) {
						[temp addObject:[[[Coordinate alloc] initWithX:current.x Y:current.y+2*direction] autorelease]];
					}
				}
			}
			if (current.x<=6) {
				if ([self getPieceAtX:current.x+1 Y:current.y+direction] && [self getPieceAtX:current.x+1 Y:current.y+direction].color != piece.color) {
					[temp addObject:[[[Coordinate alloc] initWithX:current.x+1 Y:current.y+direction] autorelease]];
				}
			}
			if (current.x>=1) {
				if ([self getPieceAtX:current.x-1 Y:current.y+direction] && [self getPieceAtX:current.x-1 Y:current.y+direction].color != piece.color) {
					[temp addObject:[[[Coordinate alloc] initWithX:current.x-1 Y:current.y+direction] autorelease]];
				}
			}
			[current release];
		}
		if (((Pawn*)piece).enPassentEnabledLeft) {
			if (piece.x != 0 && ![self getPieceAtX:piece.x-1 Y:piece.y==3?2:5]) {
				[temp addObject:[[[Coordinate alloc] initWithX:piece.x-1 Y:piece.y==3?2:5] autorelease]];
			}
		}
		if (((Pawn*)piece).enPassentEnabledRight) {
			if (piece.x != 7 && ![self getPieceAtX:piece.x+1 Y:piece.y==3?2:5]) {
				[temp addObject:[[[Coordinate alloc] initWithX:piece.x+1 Y:piece.y==3?2:5] autorelease]];
			}
		}
	}
	
	//Castling - right now its disabled
	/*if ([piece isKindOfClass:[King class]] && !piece.moved) {
		ChessPiece * rook = [self getPieceAtX:0 Y:piece.y];
		if (rook && !rook.moved) {
			BOOL canCastle = YES;
			for (int i = 1; i<piece.x; i++) {
				if ([self getPieceAtX:i Y:piece.y]) {
					canCastle = NO;
					break;
				}
			}
			if (canCastle) {
				[temp addObject:[[[Coordinate alloc] initWithX:2 Y:piece.y] autorelease]];
			}
		}
		rook = [self getPieceAtX:7 Y:piece.y];
		if (rook && !rook.moved) {
			BOOL canCastle = YES;
			for (int i = piece.x+1; i<7; i++) {
				if ([self getPieceAtX:i Y:piece.y]) {
					canCastle = NO;
					break;
				}
			}
			if (canCastle) {
				[temp addObject:[[[Coordinate alloc] initWithX:6 Y:piece.y] autorelease]];
			}
		}
	}*/
	
	return [NSArray arrayWithArray:temp];
}

- (void)movePiece:(ChessPiece *)piece toX:(int)x Y:(int)y withDelay:(NSTimeInterval)seconds {
	if ([piece isKindOfClass:[Pawn class]]) {
		((Pawn*)piece).enPassentEnabledLeft = NO;
		((Pawn*)piece).enPassentEnabledRight = NO;
		if (abs(piece.y - y) == 2) {
			if (x != 0) {
				if ([[self getPieceAtX:x-1 Y:y] isKindOfClass:[Pawn class]] && [self getPieceAtX:x-1 Y:y].color != piece.color) {
					((Pawn*)[self getPieceAtX:x-1 Y:y]).enPassentEnabledRight = YES;
				}
			}
			if (x != 7) {
				if ([[self getPieceAtX:x+1 Y:y] isKindOfClass:[Pawn class]] && [self getPieceAtX:x+1 Y:y].color != piece.color) {
					((Pawn*)[self getPieceAtX:x+1 Y:y]).enPassentEnabledLeft = YES;
				}
			}
		}
	}
	[[piece retain] autorelease]; //so it isn't released when its taken out of the model
	[[self.board objectAtIndex:piece.x] replaceObjectAtIndex:piece.y withObject:[NSNull null]];
	piece.x = x;
	piece.y = y;
	piece.moved = YES;
	
	[self finishPieceMovement:piece withDelay:seconds];
	
	if ([piece isKindOfClass:[Pawn class]] && (piece.y == 0 || piece.y == 7)) {
		((Pawn*)piece).promoted = YES;
		if ([self.delegate respondsToSelector:@selector(pawnPromotedToQueen:)]) {
			[self.delegate pawnPromotedToQueen:piece];
		}
	}
}

#pragma mark - Private Methods

- (void)setPiece:(ChessPiece*)piece atX:(int)x Y:(int)y {
	if ([self getPieceAtX:x Y:y] != nil) {
		if ([self.delegate respondsToSelector:@selector(pieceRemoved:)]) {
			[self.delegate pieceRemoved:[self getPieceAtX:x Y:y]];
		}
	}
	[[self.board objectAtIndex:x] replaceObjectAtIndex:y withObject:piece];
	piece.x = x;
	piece.y = y;
}

- (void)removePiece:(ChessPiece *)piece {
	[[self.board objectAtIndex:piece.x] replaceObjectAtIndex:piece.y withObject:[NSNull null]];
	if ([self.delegate respondsToSelector:@selector(pieceRemoved:)]) {
		[self.delegate pieceRemoved:piece];
	}
}

- (void)finishPieceMovement:(ChessPiece*)piece withDelay:(NSTimeInterval)seconds {
	[self setPiece:piece atX:piece.x Y:piece.y];
}

@end
