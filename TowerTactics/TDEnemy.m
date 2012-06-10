//
//  TDEnemy.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/9/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import "TDEnemy.h"
#import "cell.h"
#import "TDJabbaEnemy.h"
#import "TDFireEnemy.h"
#import "TDIceEnemy.h"
#import "TDWormEnemy.h"

#define RIGHT 0
#define UP 1
#define LEFT  2
#define DOWN 3
#define ADJUST 30

@implementation TDEnemy

-(void) changeDirection{
	if(cellIndex +1 != [[path getCells] count]){
		Cell* currentCell = [[path getCells] objectAtIndex:cellIndex ];
		Cell* nextCell = [[path getCells] objectAtIndex:cellIndex + 1];
		if([nextCell row] == [currentCell row]){
			if([nextCell col] > [currentCell col]) direction = RIGHT;
			else direction = LEFT;
		}else{
			if([nextCell row] > [currentCell row]) direction = DOWN;
			else direction = UP;
		}
		cellIndex++;
		UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"e%d-%d.png", enemyType, direction]];
		[iv setImage:image];
		image = [UIImage imageNamed:[NSString stringWithFormat:@"f%d.png", direction]];
		[freezeView setImage:image];
	}
}

+(id) newEnemy:(int)p move:(float)m health:(int)h inMainView:(mainview *)mv path:(TDPath *)pa pauseTime:(int)time{
	switch (p) {
		case 0:
			return [[TDWormEnemy alloc] initWithMove:m health:h inMainView:mv path:pa pauseTime:time];
		case 1:
			return [[TDJabbaEnemy alloc] initWithMove:m health:h inMainView:mv path:pa pauseTime:time];
		case 2:
			return [[TDFireEnemy alloc]initWithMove:m health:h inMainView:mv path:pa pauseTime:time];
		case 3:
			return [[TDIceEnemy alloc] initWithMove:m health:h inMainView:mv path:pa pauseTime:time];
		default:
			return nil;
	}
}


-(id) initWithMove:(float)m health:(int)h inMainView:(mainview*)mv path:(TDPath*)pa pauseTime:(int)time{
	if(self = [super init]){		
		int x = unsnap( [[[pa getCells] objectAtIndex:0 ] col]);
		int y = unsnap([[[pa getCells] objectAtIndex:0 ] row]);
		path = pa;
		movement = curMovement = m;
		cellIndex = 0;
		health = h;
		moneyGiven = h / 10;
		enemyType = 1;
		freezeIndex = 0;
        pauseTime = time;
		UIImage * image = [UIImage imageNamed:@"e0-0.png"];
		iv = [[UIImageView alloc] initWithImage:image];
		[iv setFrame: CGRectMake(x, y, 40, 40)];
		[mv.view addSubview:iv];
		[mv.view bringSubviewToFront:iv];
		UIImage * freezeImage = [UIImage imageNamed: @"f0.png"];
		freezeView = [[UIImageView alloc] initWithImage:freezeImage];
		[freezeView setFrame: CGRectMake(x, y, 40, 40)];
		[mv.view addSubview:freezeView];
		[mv.view bringSubviewToFront:freezeView];
		[freezeView setAlpha:0];
	}
	return self;

}

-(float) aimX{
	if(direction == RIGHT) return (int)(iv.center.x + ADJUST - (freezeIndex * 10));
	if(direction == LEFT)return (int)(iv.center.x - ADJUST + (freezeIndex * 10));
	return (int)iv.center.x;
}
-(float) aimY{
	if(direction == DOWN) return (int)(iv.center.y + ADJUST - (freezeIndex * 10));
	if(direction == UP) return (int)(iv.center.y - ADJUST + (freezeIndex * 10));
	return (int)iv.center.y;
}

-(int) getTailCol{
	if(direction == RIGHT) return gridSnap((int)iv.center.x - 20);
	if(direction == LEFT)return gridSnap((int)iv.center.x + 20);
	return gridSnap((int)iv.center.x);
}
-(int) getTailRow{
	if(direction == DOWN) return gridSnap((int)iv.center.y - 20);
	if(direction == UP) return gridSnap((int)iv.center.y + 20);
	return gridSnap((int)iv.center.y);
}

-(void) checkDirection{
	Cell* prospectiveCell = [[path getCells] objectAtIndex:cellIndex ];
    
	if([self getTailCol] == [prospectiveCell col] && [self getTailRow] == [prospectiveCell row])
		[self changeDirection];
}

-(void) death{
	if([iv alpha] == 1){
		UIImage * image = [UIImage imageNamed:@"edeath.png"];
		[iv setImage:image];
		[freezeView removeFromSuperview];
	}
	[iv setAlpha:[iv alpha] - .01];
}

-(int) getMoneyGiven{ return moneyGiven;}

-(int) getPauseTime{ return pauseTime;}

-(void) defrost{
	[freezeView setAlpha:[freezeView alpha] - (.03 / freezeIndex)];
	if(![self isFrozen]){
		curMovement = movement;
		freezeIndex = 0;
	}
}

-(void) move{
	if(health > 0){
		switch (direction) {
			case LEFT:
				iv.center = CGPointMake(iv.center.x - curMovement, iv.center.y);
				freezeView.center = CGPointMake(iv.center.x - curMovement, iv.center.y);
				break;
			case RIGHT:
				iv.center = CGPointMake(iv.center.x + curMovement, iv.center.y);
				freezeView.center = CGPointMake(iv.center.x + curMovement, iv.center.y);
				break;
			case DOWN:
				iv.center = CGPointMake(iv.center.x, iv.center.y + curMovement);
				freezeView.center = CGPointMake(iv.center.x, iv.center.y + curMovement);
				break;
			case UP:
				iv.center = CGPointMake(iv.center.x, iv.center.y - curMovement);
				freezeView.center = CGPointMake(iv.center.x, iv.center.y - curMovement);
				break;
			default:
				break;
		}
		if([self isFrozen]) [self defrost];;
		[self checkDirection];
	}else{
		[self death];
	}
}
-(void) attack:(int)d freezeIndex:(int) f{
	health -= d;
    if(f > 0 ){
        [freezeView setAlpha:1];
        freezeIndex = f;
        curMovement = movement /(1.5 + (.5 * f));
    }
}

-(BOOL) isDead{return (health <= 0);}
-(BOOL) isFrozen{ return ( [freezeView alpha] > 0); }
-(BOOL) isActive{return ([iv alpha] > 0);}
-(BOOL) outsideBounds{
	return (iv.center.x > 340 || iv.center.x < -20 || iv.center.y > 500 || iv.center.y < -20); 
}
-(BOOL) wontTravelOutsideBounds{
	switch (direction) {
		case LEFT:
			return (iv.center.x >= 20);
		case RIGHT:
			return (iv.center.x <= 300);
		case DOWN:
			return (iv.center.y <= 460);
		case UP:
			return (iv.center.y >= 20);
		default:
			return FALSE;
	}	
}

-(void) dealloc{	
	NSLog(@"ENEMY DEALLOCED");
	[freezeView release];
	[iv release];
	[super dealloc];
}
@end
