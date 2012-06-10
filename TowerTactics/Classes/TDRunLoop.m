//
//  TDRunLoop.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/9/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import "TDRunLoop.h"
#import "TDEnemy.h"
#import "TDTower.h"
#import "TDBullet.h"

@implementation TDRunLoop

-(id) initWithMV: (mainview*) mv money:(int)startingMoney{
	if(self = [super init]){
		enemies = [[NSMutableArray alloc] init];
		bullets = [[NSMutableArray alloc] init];
		towers = [[NSMutableArray alloc] init];
		enemyCleanup = [[NSMutableSet alloc] init];
		bulletCleanup = [[NSMutableSet alloc] init];
		mview = mv;
		secondaryTimer = 0;
        numKills = 0;
		money = startingMoney;
		lives = 20;
		[self initializeVariables];
	}
	return self;
}
-(void) run: (TDPath *) p enemies:(NSArray*)enemiesArray{
   	generator = [[TDEnemyGenerator alloc] initWithMV:mview path:p enemyData:enemiesArray];
    [mview setStatusWithLives:lives Money: money Kills:numKills ofTotal:[generator numTotalEnemies]];
}

-(void) enemyActions{
	for(TDEnemy * enemy in enemies) {
		[enemy move];
		if([enemy isDead] && ![enemy isActive] && ![enemyCleanup containsObject:enemy]){
			money += [enemy getMoneyGiven];
            numKills++;
			[enemyCleanup addObject:enemy];
			[mview setStatusWithLives:lives Money: money Kills:numKills ofTotal:[generator numTotalEnemies]];
		}
		if([enemy outsideBounds] && ![enemyCleanup containsObject:enemy]) {
			[enemyCleanup addObject:enemy];
			lives = max(lives - 1, 0);
            [mview setStatusWithLives:lives Money: money Kills:numKills ofTotal:[generator numTotalEnemies]];
		}
	}
}

-(void) towerActions{
	for(TDTower * tower in towers){
		[tower action:enemies withBullets:bullets];
	}
}

-(void) bulletActions{
	for(TDBullet * bullet in bullets){
		[bullet move];
		if([bullet isFinished]) [bulletCleanup addObject:bullet];
	}
}

-(void) cleanup{
	for (TDEnemy* enemy in enemyCleanup){
		[enemies removeObject:enemy];
	}
	[enemyCleanup removeAllObjects];
	for (TDBullet* bullet in bulletCleanup){
		[bullets removeObject:bullet];
	}
	[bulletCleanup removeAllObjects];
}

-(void) uponTimer{
    if(![generator hasMoreEnemies] && enemies.count == 0){    
        [mview victory];
    }
    if(lives > 0){
        [self towerActions];
    }else{
        [mview failure];
    }
    [self enemyActions];
    [self bulletActions];
    if(secondaryTimer == 0) [self cleanup];
    if(secondaryTimer % 50 == 0) {
        [generator next:enemies];
    }
    secondaryTimer = (secondaryTimer + 1) % 100;	
}

- (void)addTower:(int)col withRow:(int)row towerType:(int)towerSelected {
	if(money >= [TDTower priceOf:towerSelected]){
		TDTower *newTower = [TDTower newTower:mview towerType:towerSelected column:col row:row];
		hasTower[col][row] = YES;
		towerGrid[col][row] = newTower;
		[towers addObject:newTower];
		[newTower release];
		money -=[TDTower priceOf:towerSelected];
        [mview setStatusWithLives:lives Money: money Kills:numKills ofTotal:[generator numTotalEnemies]];
	}
}

-(void)initializeVariables {
	for (int col = 0; col < 8; col++) {
		for (int row = 0; row < 11; row++) {
			hasTower[col][row] = NO;
		}
	}
	for (int col = 0; col < 8; col++) {
		for (int row = 0; row < 11; row++) {
			towerGrid[col][row] = nil;
		}
	}
}

-(BOOL)hasTowerInCol:(int)col andRow:(int)row {
	return hasTower[col][row];
}

- (void)sellTower:(int)col withRow:(int)row {
	TDTower *currentTower = towerGrid[col][row];
	money += [currentTower sellValue];
    [mview setStatusWithLives:lives Money: money Kills:numKills ofTotal:[generator numTotalEnemies]];
    [currentTower removeFromSuperview];
	[towers removeObject:currentTower];
	hasTower[col][row] = NO;
	towerGrid[col][row] = nil;
}

- (void)levelUp:(int)col withRow:(int)row {
	TDTower *currentTower = towerGrid[col][row];
	if (currentTower.currentLevel < 2 && money >= [currentTower levelUpCost]) { // Max level is 2
		money -= [currentTower levelUpCost];
		[currentTower levelUpCurrentTower];
        [mview setStatusWithLives:lives Money: money Kills:numKills ofTotal:[generator numTotalEnemies]];
	}
}

- (void)pause {
	[timer invalidate];
	[mview pause];
}

- (void)playAgain {
	timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(uponTimer) userInfo:nil repeats:YES];
	[mview play];
}	

-(int) getLives{
	return lives;
}
-(void) dealloc{
	[enemies release];
	[bullets release];
	[towers release];
	[enemyCleanup release];
	[bulletCleanup release];
	[super dealloc];
}

@end
