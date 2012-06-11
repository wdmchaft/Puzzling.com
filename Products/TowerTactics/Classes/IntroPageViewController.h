//
//  IntroPageViewController.h
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainview.h"
#import "InstructionPageViewController.h"
#import "InfoPageViewController.h"
#import "DifficultyPageViewController.h"
#import "TDEnemyChooserViewController.h"


@interface IntroPageViewController : UIViewController {
	IBOutlet UIButton *beginButton;
	IBOutlet UIButton *instructionButton;
	IBOutlet UIButton *infoButton;
	IBOutlet UILabel *titleLine;
	mainview *mv;
	TDEnemyChooserViewController *instructions;
	InstructionPageViewController *info;
	DifficultyPageViewController *difficulty;
	NSString *difficultyString;
}

@property (nonatomic, retain) IBOutlet UILabel* ratingLabel;


-(void)beginGame;
-(IBAction)getInstructions;
-(IBAction)getInfo;
-(IBAction)play;
-(void)dismissCurrentVC;
-(IBAction)getDifficulty;
-(void)setDifficultyString:(NSString *)d;

@end
