//
//  TDIceEnemy.m
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "TDIceEnemy.h"


@implementation TDIceEnemy


-(id) initWithMove:(float)m health:(int)h inMainView:(mainview*)mv path:(TDPath*)pa pauseTime:(int)time{
    if(self = [super initWithMove:m health:h inMainView:mv path:pa pauseTime:time]){		
		enemyType = 3;
		UIImage * image = [UIImage imageNamed:@"e3-0.png"];
		iv.image = image;
		[self changeDirection];
	}
	return self;
}


-(void) attack:(int)d freezeIndex:(int) f{
	health -= d;
}


@end
