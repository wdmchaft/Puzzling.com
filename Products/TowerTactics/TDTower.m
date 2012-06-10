//
//  TDTower.m
//  Final Project
//
//  Created by nadiafx on 10/03/13.
//  Copyright 2010 Harvard University. All rights reserved.
//

#import "TDTower.h"
#import "TDBullet.h"
#import "TDEnemy.h"
#import "TDStandardTower.h"
#import "TDIceTower.h"
#import "TDSniperTower.h"
#import "TDFireTower.h"
#import "TDDemonTower.h"

@implementation TDTower
@synthesize currentLevel;

+(id) newTower:(mainview*)mv towerType:(int)type column:(int)col row:(int)row{
		switch (type) {
			case 0:
				return [[TDStandardTower alloc] initWithMainView:mv column:col row:row];
			case 1:
				return [[TDFireTower alloc] initWithMainView:mv column:col row:row];
			case 2:
				return [[TDIceTower alloc] initWithMainView:mv column:col row:row];
			case 3:
				return [[TDSniperTower alloc] initWithMainView:mv column:col row:row];
			case 4:
				return [[TDDemonTower alloc] initWithMainView:mv column:col row:row];
			default:
				return nil;
		}
}

-(id) initWithMainView:(mainview*)mv column:(int)col row:(int)row{
	NSLog(@"ERROR: DON'T ALLOC INIT THE SUPERCLASS");
	return nil;
}



-(void) removeFromSuperview {
	[iv removeFromSuperview];
	iv = nil;
}

-(int) distanceX1:(int)a Y1:(int)b X2:(int)c Y2:(int)d{
	return (int)sqrt((double)((a -c)*(a -c)) + ((b -d)*(b -d)));
}
-(void) action:(NSMutableArray*) enemies withBullets:(NSMutableArray*)bullets{
	if(secondaryTimer >= delayFire){
		for(TDEnemy * enemy in enemies) {
			//NSLog(@"Is Alive%d",![enemy isDead]);
			//NSLog(@"wont travel out%d",[enemy wontTravelOutsideBounds]);
			int dist = [self distanceX1:(int)iv.center.x  Y1:(int)iv.center.y X2:[enemy aimX] Y2:[enemy aimY]];
			if(![enemy isDead] && [enemy wontTravelOutsideBounds] && dist <= range ){
				TDBullet* b = [[TDBullet alloc] initWithEnemy:enemy inMV:mview xLoc:(int)iv.center.x
														yLoc:(int)iv.center.y damage:damage freeze:freeze distance:dist
														 type:type];
				[bullets addObject:b];
				[b release];
				secondaryTimer = 0;
				break;
			}
		}
	}
	else secondaryTimer ++;
}

-(void)levelUpCurrentTower {
	currentLevel++;
	[iv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"t%d-%d.png", type, currentLevel]]];
	damage *= 1.7;
	range *= 1.15;
	delayFire *=.8;
}


+(int)priceOf:(int)towerSelected{
	switch (towerSelected) {
		case 0:
			return 50;
		case 1:
			return 75;
		case 2:
			return 75;
		case 3:
			return 75;
		case 4:
			return 125;
		default:
			return 0;
	}
}

-(int)levelUpCost{
	return  (currentLevel + 1) * 75;
}
-(int) sellValue{
	return (currentLevel + 1) * 50;
}

-(void) dealloc{	// This is kind of buggy
	//NSLog(@"TOWER DEALLOCED");
	[iv release];
	[super dealloc];
}

@end
