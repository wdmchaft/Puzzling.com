//
//  TDFireTower.m
//  Final Project
//
//  Created by nadiafx on 10/03/15.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "TDFireTower.h"


@implementation TDFireTower

-(id) initWithMainView:(mainview*)mv  column:(int)realColumn row:(int)realRow {
	if(self = [super init]){		
		UIImage *image = [UIImage imageNamed:@"t1-0.png"];
		type = 1;
		currentLevel = 0;
		column = realColumn;
		row = realRow;
		range = 100.0;
		iv = [[UIImageView alloc] initWithImage:image];
		mview = mv;
		damage = 7;
		freeze = 0;
		delayFire = 75;
		secondaryTimer = delayFire;
		[iv setFrame: CGRectMake(unsnap(realColumn), unsnap(realRow), 40, 40)];
		[mview.view addSubview:iv];
		[mview.view bringSubviewToFront:iv];
		[iv release];
	}
	return self;
}

-(void)levelUpCurrentTower {
	[super levelUpCurrentTower];
	damage *= 1.2 ;
}

-(int)levelUpCost{
	if(currentLevel == 0) return 150;
	return 150;
}
-(int) sellValue{
	if(currentLevel == 0) return 75 * .75;
	if(currentLevel == 1) return 225 * .75;
	return 375 * .75;
}

@end
