//
//  TDBullet.h
//  Final Project
//
//  Created by Jonathan Tilley on 3/14/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDEnemy.h"
#import "mainview.h"

@class TDBullet;

@interface TDBullet : NSObject {
	UIImageView * iv;
	mainview * mview;
	TDEnemy * enemy;
	int damage;
	int freeze;
	int secondaryTimer;
	int NSTEPS;
	float dx;
	float dy;
	BOOL finished;
}
-(id) initWithEnemy:(TDEnemy*)e inMV:(mainview*)mv xLoc:(int) x yLoc:(int)y damage:(int)d freeze:(int)f distance:(int)dist type:(int)t;
-(void) move;
-(BOOL) isFinished;
@end
