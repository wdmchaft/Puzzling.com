//
//  PlayPuzzleViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 4/30/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PuzzleModel;

@interface PlayPuzzleViewController : UIViewController {
	NSDictionary *__setupData;
	NSDictionary *__solutionData;
}

@property (nonatomic, readwrite, retain) NSDictionary *setupData; //for setting in subclasses nil is default
@property (nonatomic, readwrite, retain) NSDictionary *solutionData; //for setting in subclasses nil is default
@property (nonatomic, readwrite, retain) PuzzleModel *puzzleModel;

- (id)initWithRated:(BOOL)rated;

//For subclass override
- (void)endTactic:(double)score;

@end
