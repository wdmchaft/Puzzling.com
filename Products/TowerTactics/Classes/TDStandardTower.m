//
//  TDStandardTower.m
//  Final Project
//
//  Created by nadiafx on 10/03/15.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "TDStandardTower.h"


@implementation TDStandardTower

-(id) initWithMainView:(mainview*)mv  column:(int)realColumn row:(int)realRow {
	if(self = [super init]){		
		UIImage *image = [UIImage imageNamed:@"t0-0.png"];
		type = 0;
		currentLevel = 0;
		column = realColumn;
		row = realRow;
		range = 100.0;
		iv = [[UIImageView alloc] initWithImage:image];
		mview = mv;
		damage = 5;
		freeze = 0;
		delayFire = 50;
		secondaryTimer = delayFire;
		[iv setFrame: CGRectMake(unsnap(realColumn), unsnap(realRow), 40, 40)];
		[mview.view addSubview:iv];
		[mview.view bringSubviewToFront:iv];
		[iv release];
	}
	return self;
}

-(int)levelUpCost{
	if(currentLevel == 0) return 100;
	return 150;
}

-(int) sellValue{
	if(currentLevel == 0) return 50 * .75;
	if(currentLevel == 1) return 150 * .75;
	return 250 * .75;
}
	


@end
