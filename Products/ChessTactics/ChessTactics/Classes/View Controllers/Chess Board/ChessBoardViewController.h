//
//  ChessBoardViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessPieces.h"


@protocol ChessBoardViewControllerDelegate;

@interface ChessBoardViewController : UIViewController

@property (nonatomic, readwrite, assign) id<ChessBoardViewControllerDelegate> delegate;
@property (nonatomic, readwrite, assign) BOOL inEditingMode;
@property (nonatomic, readonly) NSArray *allPieces;
@property (nonatomic, readwrite, assign) BOOL fullBoard;
@property (nonatomic, readwrite, assign) Color playerColor; 

- (id)initWithColor:(Color)newColor;
- (int)squareSize;
- (void)addPiece:(Class)ChessPieceType withColor:(Color)color toLocation:(CGPoint)loc;

@end

@protocol ChessBoardViewControllerDelegate <NSObject>

- (void)piece:(ChessPiece *)piece willMoveToX:(int)x Y:(int)y;

@end
