//
//  TDTower.h
//  Final Project
//
//  Created by nadiafx on 10/03/13.
//  Copyright 2010 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mainview.h"

@class TDTower;

@interface TDTower : NSObject {
	UIImageView *iv;
	mainview * mview;
	int column;
	int row;
	int type;
	int currentLevel;
	int damage;
	int freeze;
	int delayFire;
	int secondaryTimer;
	float range;
}


@property int currentLevel;

+(id) newTower:(mainview*)mv towerType:(int)type column:(int)col row:(int)row;
-(id) initWithMainView:(mainview*)mv column:(int)col row:(int)row;
-(void) action:(NSMutableArray*) enemies withBullets:(NSMutableArray*)bullets;
-(int) distanceX1:(int)a Y1:(int)b X2:(int)c Y2:(int)d;
-(void) removeFromSuperview;
-(void)levelUpCurrentTower;
-(int) levelUpCost;
-(int) sellValue;
+(int)priceOf:(int)towerSelected;
@end
