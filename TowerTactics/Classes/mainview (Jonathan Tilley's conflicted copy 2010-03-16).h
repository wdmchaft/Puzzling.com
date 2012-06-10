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


@class mainview;

@interface mainview : UIViewController {
	TDPath * path;
	id mainRun;
	UIImageView * status;
	UIImageView * playButton;
	UIImageView * failure;
	UILabel * money;
	UILabel * lives;
	int towerSelected;
	int currentLevel;
	BOOL sellingMode;
	BOOL playMode;
	BOOL levelupMode;
	BOOL isPath[12][8];  // currently [row][col]
}

@property int towerSelected;

- (void)initializeVariables;
-(void) setStatusLives:(int)l Money:(int)m;
-(void) pause;
-(void) play;
-(void) failure;


@end

