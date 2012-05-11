//
//  AnalysisBoardViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/8/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleModel.h"


@interface AnalysisBoardViewController : UIViewController

@property (nonatomic, readwrite, retain) PuzzleModel *puzzleModel;
@property (nonatomic, readwrite, assign) BOOL computerMoveFirst; 

@end
