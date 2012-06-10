//
//  TDFireEnemy.m
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "TDFireEnemy.h"


@implementation TDFireEnemy


-(id) initWithMove:(float)m health:(int)h inMainView:(mainview*)mv path:(TDPath*)pa pauseTime:(int)time{
    if(self = [super initWithMove:m health:h inMainView:mv path:pa pauseTime:time]){		
		health = h * 1.5;
		enemyType = 2;
		UIImage * image = [UIImage imageNamed:@"e2-0.png"];
		iv.image = image;
		[self changeDirection];
	}
	return self;
}

-(void) attack:(int)d freezeIndex:(int) f{
	health -= d;
	if(f > 0){
		[freezeView setAlpha:1];
		freezeIndex = f;
		curMovement = movement/(2 + (.5 * f));
	}
}

-(void) defrost{
	[freezeView setAlpha:[freezeView alpha] - (.03 / freezeIndex)];
	if(![self isFrozen]){
		curMovement = movement;
		freezeIndex = 0;
	}
}

@end
