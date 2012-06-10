//
//  TDDemonTower.m
//  Final Project
//
//  Created by nadiafx on 10/03/15.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "TDDemonTower.h"
#import "TDEnemy.h"
#import "TDBullet.h"

@implementation TDDemonTower

-(id) initWithMainView:(mainview*)mv  column:(int)realColumn row:(int)realRow {
	if(self = [super init]){		
		UIImage *image = [UIImage imageNamed:@"t4-0.png"];
		type = 4;
		currentLevel = 0;
		column = realColumn;
		row = realRow;
		range = 100.0;
		iv = [[UIImageView alloc] initWithImage:image];
		mview = mv;
		damage = 5;
		freeze = 0;
		delayFire = 100;
		secondaryTimer = delayFire;
		[iv setFrame: CGRectMake(unsnap(realColumn), unsnap(realRow), 40, 40)];
		[mview.view addSubview:iv];
		[mview.view bringSubviewToFront:iv];
		[iv release];
	}
	return self;
}

-(void) action:(NSMutableArray*) enemies withBullets:(NSMutableArray*)bullets{
	if(secondaryTimer >= delayFire){
		for(TDEnemy * enemy in enemies) {
			int dist = [super distanceX1:(int)iv.center.x  Y1:(int)iv.center.y X2:[enemy aimX] Y2:[enemy aimY]];
			if(![enemy isDead] && dist <= range ){
				TDBullet* b = [[TDBullet alloc] initWithEnemy:enemy inMV:mview xLoc:(int)iv.center.x
														 yLoc:(int)iv.center.y damage:damage freeze:freeze distance:dist
														 type:type];
				[bullets addObject:b];
				[b release];
				secondaryTimer = 0;
			}
		}
	}
	else secondaryTimer ++;
}

-(int)levelUpCost{
	if(currentLevel == 0) return 200;
	return 250;
}

-(int) sellValue{
	if(currentLevel == 0) return 125 * .75;
	if(currentLevel == 1) return 325 * .75;
	return 575 * .75;
}
@end
