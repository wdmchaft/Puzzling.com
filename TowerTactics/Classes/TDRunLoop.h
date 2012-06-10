//
//  TDRunLoop.h
//  Final Project
//
//  Created by Jonathan Tilley on 3/9/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mainview.h"
#import "TDPath.h"
#import "TDEnemyGenerator.h"

@class TDRunLoop;

@interface TDRunLoop : NSObject {
	NSTimer *timer;
	mainview * mview;
	TDPath * path;
	TDEnemyGenerator * generator;
	NSMutableArray * enemies;
	NSMutableArray * bullets;
	NSMutableArray * towers;
	NSMutableSet * enemyCleanup;
	NSMutableSet * bulletCleanup;
	int secondaryTimer;
	int money;
	int lives;
    int numKills;
	BOOL hasTower[8][11];
	id towerGrid[8][11]; 

}

-(id) initWithMV: (mainview*) mv money:(int)startingMoney;
-(void) run: (TDPath *) p enemies:(NSArray*)enemies;
- (void)addTower:(int)col withRow:(int)row towerType:(int)towerSelected;
-(void)initializeVariables;
-(BOOL)hasTowerInCol:(int)col andRow:(int)row;
- (void)sellTower:(int)col withRow:(int)row;
- (void)levelUp:(int)col withRow:(int)row;
- (void)pause;
- (void)playAgain;
-(int) getLives;
-(int) getNumKills;


@end
