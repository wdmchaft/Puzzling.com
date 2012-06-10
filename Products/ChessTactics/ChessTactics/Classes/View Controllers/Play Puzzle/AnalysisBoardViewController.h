//
//  AnalysisBoardViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/8/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleModel.h"


@interface AnalysisBoardViewController : UIViewController

@property (nonatomic, readwrite, retain) NSDictionary *setupData;
@property (nonatomic, readwrite, assign) BOOL computerMoveFirst; 

@end
