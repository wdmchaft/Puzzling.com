//
//  CreatePuzzleViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessPieces.h"


@interface CreatePuzzleViewController : UIViewController

@property (nonatomic, readwrite, assign) Color playerColor;
@property (nonatomic, readwrite, assign) BOOL fullBoard;
@property (nonatomic, readwrite, assign) BOOL computerMoveFirst;

@end
