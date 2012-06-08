//
//  ChessModel.h
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChessPieces.h"

@protocol ChessModelDelegate;

@interface ChessModel : NSObject

@property (nonatomic, readwrite, assign) id<ChessModelDelegate> delegate;

- (void)setUpBoard;
- (ChessPiece*)getPieceAtX:(int)x Y:(int)y;
- (NSArray*)getLegalMovesForPiece:(ChessPiece*)piece;
- (void)movePiece:(ChessPiece*)piece toX:(int)x Y:(int)y withDelay:(NSTimeInterval)seconds;
- (void)removePiece:(ChessPiece *)piece;

@end

@protocol ChessModelDelegate <NSObject>

- (void)pawnPromotedToQueen:(ChessPiece *)pawn;
- (void)pieceRemoved:(ChessPiece *)piece;

@end