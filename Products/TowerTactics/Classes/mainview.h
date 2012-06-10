//
//  Final_ProjectViewController.h
//  Final Project
//
//  Created by Jonathan Tilley on 3/7/10.
//  Copyright Stanford 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDPath.h"
#import "cell.h"
#import "TDBackgroundViewController.h"


@class mainview;
@class IntroPageViewController;

@interface mainview : TDBackgroundViewController {
	TDPath * path;
	id mainRun;
	UIImageView * status;
	UIImageView * playButton;
	UIImageView * failure;
	UILabel * money;
	UILabel * lives;
    UILabel * kills;
    UIButton * quit;

	int towerSelected;
	int currentLevel;
	BOOL sellingMode;
	BOOL playMode;
	BOOL levelupMode;
	BOOL victoried;
    float score;
	UIViewController *introPage;
	UIImageView * selectedButton;
}

@property int towerSelected;
@property (nonatomic, retain) UIViewController *introPage;
@property (nonatomic, retain) NSString* puzzleID;
@property (nonatomic, retain) NSString* puzzleName;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil path:(NSString*)pathName enemies:(NSArray*)enemies;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cells:(NSArray*)c enemies:(NSArray*)enemies money:(int)startingMoney;
- (void)initializeVariables;
-(void) setStatusWithLives:(int)l Money:(int)m Kills:(int)k ofTotal:(int)total;
-(void) pause;
-(void) play;
-(void) failure;
-(void) victory;
-(void) dismissSelf;
-(void) select:(int)col;

@end

