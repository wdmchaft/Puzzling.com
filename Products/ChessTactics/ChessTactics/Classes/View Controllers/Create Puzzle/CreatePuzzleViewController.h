//
//  CreatePuzzleViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessPieces.h"


@interface CreatePuzzleViewController : UIViewController

@property (nonatomic, readwrite, assign) Color playerColor;
@property (nonatomic, readwrite, assign) BOOL fullBoard;

@end
