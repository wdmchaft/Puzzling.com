//
//  TDIceTower.m
//  Final Project
//
//  Created by nadiafx on 10/03/15.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "TDIceTower.h"


@implementation TDIceTower

-(id) initWithMainView:(mainview*)mv  column:(int)realColumn row:(int)realRow {
	if(self = [super init]){		
		UIImage *image = [UIImage imageNamed:@"t2-0.png"];
		type = 2;
		currentLevel = 0;
		column = realColumn;
		row = realRow;
		range = 100.0;
		iv = [[UIImageView alloc] initWithImage:image];
		mview = mv;
		damage = 4;
		freeze = 1;
		delayFire = 60;
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
	freeze++;
}

-(int)levelUpCost{
	if(currentLevel == 0) return 150;
	return 175;
}

-(int) sellValue{
	if(currentLevel == 0) return 75 * .75;
	if(currentLevel == 1) return 225 * .75;
	return 500 * .75;
}

@end
