//
//  TDJabbaEnemy.m
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "TDJabbaEnemy.h"

@implementation TDJabbaEnemy


-(id) initWithMove:(float)m health:(int)h inMainView:(mainview*)mv path:(TDPath*)pa pauseTime:(int)time{
	if(self = [super initWithMove:m health:h inMainView:mv path:pa pauseTime:time]){		
        movement = curMovement = m * 1.3;
		health = h * .7;
		enemyType = 1;
		UIImage * image = [UIImage imageNamed:@"e1-0.png"];
		iv.image = image;
		[self changeDirection];
	}
	return self;
}

@end
