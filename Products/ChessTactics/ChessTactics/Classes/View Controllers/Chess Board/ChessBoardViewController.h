//
//  ChessBoardViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessPieces.h"


@class Coordinate;
@protocol ChessBoardViewControllerDelegate;

@interface ChessBoardViewController : UIViewController

@property (nonatomic, readwrite, assign) id<ChessBoardViewControllerDelegate> delegate;
@property (nonatomic, readwrite, assign) BOOL inEditingMode;
@property (nonatomic, readonly) NSArray *allPieces;
@property (nonatomic, readwrite, assign) BOOL fullBoard;
@property (nonatomic, readwrite, assign) Color playerColor;
@property (nonatomic, readwrite, assign) BOOL interactionAllowed;

- (id)initWithColor:(Color)newColor;
- (int)squareSize;
- (void)addPiece:(Class)ChessPieceType withColor:(Color)color toLocation:(CGPoint)loc;
- (void)addPiece:(Class)ChessPieceType withColor:(Color)color toCoordinate:(Coordinate *)coord;
- (void)movePieceFromX:(int)startX Y:(int)startY toX:(int)finishX Y:(int)finishY;
- (void)setupPieces:(NSArray *)pieces;

@end

@protocol ChessBoardViewControllerDelegate <NSObject>

@optional
- (void)piece:(ChessPiece *)piece didMoveFromX:(int)x Y:(int)y;

@end
