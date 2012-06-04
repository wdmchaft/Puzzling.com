//
//  PlayPuzzleViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 4/30/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleSDK.h"


#define SHOW_SOLUTION @"Show Solution"

@class PuzzleModel;

@interface PlayPuzzleViewController : UIViewController {
	NSDictionary *__setupData;
	NSDictionary *__solutionData;
}

@property (nonatomic, readwrite, retain) NSDictionary *setupData; //for setting in subclasses nil is default
@property (nonatomic, readwrite, retain) NSDictionary *solutionData; //for setting in subclasses nil is default
@property (nonatomic, readwrite, retain) PuzzleModel *puzzleModel;
@property (nonatomic, readwrite, retain) PuzzleID *puzzleID; //If set, will get specific puzzle
@property (nonatomic, readwrite, assign) BOOL rated;
@property (nonatomic, readwrite, retain) UILabel *bottomLabel; //for use by guest subclass

- (id)initWithRated:(BOOL)rated;

//For subclass override
- (void)endTactic:(double)score;
- (void)presentNextTactic;
- (IBAction)menuPressed:(id)sender;
- (void)showPuzzleFailMessage:(double)score;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
