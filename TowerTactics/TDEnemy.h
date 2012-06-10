//
//  TDEnemy.h
//  Final Project
//
//  Created by Jonathan Tilley on 3/9/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mainview.h"
#import "TDPath.h"


@interface TDEnemy : NSObject {
	UIImageView * iv;
	UIImageView * freezeView;
	TDPath * path;
	int enemyType;
	float movement;
    float curMovement;
	int direction;
	int cellIndex;
	int health;
	int freezeIndex;
	int moneyGiven;
    int pauseTime;
}
-(void) changeDirection;
-(id) initWithMove:(float)m health:(int)h inMainView:(mainview*)mv path:(TDPath*)pa pauseTime:(int)time;
+(id) newEnemy:(int)p move:(float)m health:(int)h inMainView:(mainview *)mv path:(TDPath *)pa pauseTime:(int)time;
-(void) move;
-(float) aimX;
-(float) aimY;
-(int) getTailCol;
-(int) getTailRow;
-(int) getMoneyGiven;
-(int) getPauseTime;
-(void) attack:(int)d freezeIndex:(int)f;
-(BOOL) isDead;
-(BOOL) isFrozen;
-(BOOL) isActive;
-(BOOL) outsideBounds;
-(BOOL)wontTravelOutsideBounds;
@end
