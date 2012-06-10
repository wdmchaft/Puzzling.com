//
//  DifficultyPageViewController.h
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainview.h"

@class IntroPageViewController;


@interface DifficultyPageViewController : UIViewController {
	IBOutlet UIButton *diffButton1;
	IBOutlet UIButton *diffButton2;
	IBOutlet UIButton *diffButton3;
	IBOutlet UIButton *diffButton4;
	IBOutlet UIButton *diffButton5;
	IBOutlet UIButton *goBack;
	
	IntroPageViewController *introPage;
}

-(IBAction)goBack;

-(IBAction)setDifficulty1;
-(IBAction)setDifficulty2;
-(IBAction)setDifficulty3;
-(IBAction)setDifficulty4;
-(IBAction)setDifficulty5;

@property (nonatomic, retain) IntroPageViewController *introPage;

@end
