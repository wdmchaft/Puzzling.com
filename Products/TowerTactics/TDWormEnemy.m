//
//  TDWormEnemy.m
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "TDWormEnemy.h"


@implementation TDWormEnemy


-(id) initWithMove:(float)m health:(int)h inMainView:(mainview*)mv path:(TDPath*)pa pauseTime:(int)time{
    if(self = [super initWithMove:m health:h inMainView:mv path:pa pauseTime:time]){		
		enemyType = 0;
		UIImage * image = [UIImage imageNamed:@"e0-0.png"];
		iv.image = image;
		[self changeDirection];
	}	return self;
}
@end
