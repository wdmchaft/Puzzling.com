//
//  TDBullet.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/14/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import "TDBullet.h"



@implementation TDBullet

-(id) initWithEnemy:(TDEnemy*)e inMV:(mainview*)mv xLoc:(int) x yLoc:(int)y damage:(int)d freeze:(int)f distance:(int)dist type:(int)t{
	if(self = [super init]){
		iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"b%d.png", t]]];
		[iv setFrame: CGRectMake(x, y, 10, 10)];
		[mv.view addSubview:iv];
		[mv.view bringSubviewToFront:iv];
		damage = d;
		freeze = f;
		enemy = e;
		secondaryTimer = 0;
		finished = FALSE;
		NSTEPS = dist/5;
		dx = ([enemy aimX] - (float)x) / NSTEPS;
		dy = ([enemy aimY] - (float)y) / NSTEPS;
	}
	return self;
}

-(void) move{
	if(secondaryTimer != NSTEPS){
		iv.center = CGPointMake(iv.center.x + dx, iv.center.y + dy);
		secondaryTimer++;
	}else if(!finished){
		if(enemy)[enemy attack:damage freezeIndex:freeze];
		[iv removeFromSuperview];
		finished = TRUE;
	}
}

-(BOOL) isFinished{
	return finished;
}

-(void) dealloc{
	[iv release];
	[super dealloc];
}
@end
