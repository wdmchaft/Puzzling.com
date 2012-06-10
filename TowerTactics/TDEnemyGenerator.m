//
//  TDEnemyGenerator.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/13/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import "TDEnemyGenerator.h"
#import "TDEnemy.h"

@implementation TDEnemyGenerator
@synthesize enemyData;

#define NUM_ENEMIES 200

-(id) initWithMV:(mainview*)mv path:(TDPath*)p enemyData:(NSArray*)data{
	if(self = [super init]){
		mview = mv;
		level = 1;
		generatorTimer = 0;
		waitTimer = 0;
		path = p;
        self.enemyData = data;
        enemyIndex = 0;
	}
	return self;
}

-(void) determinedNext:(NSMutableArray*)enemies{
    if([self hasMoreEnemies]){
        waitTimer++;
        if(waitTimer >= [[[enemyData objectAtIndex:enemyIndex] objectForKey:@"pauseTime"] integerValue]){
            NSDictionary* singleEnemyData = [enemyData objectAtIndex:enemyIndex];
            TDEnemy * enemy = [TDEnemy newEnemy:[[singleEnemyData objectForKey:@"enemyType"]integerValue]
                                           move:[[singleEnemyData objectForKey:@"enemyMovement"]floatValue]
                                         health:[[singleEnemyData objectForKey:@"enemyHealth"]integerValue]
                                     inMainView:mview 
                                           path:path 
                                      pauseTime:[[singleEnemyData objectForKey:@"pauseTime"]integerValue]];
            [enemies addObject: enemy];
            [enemy release];
            waitTimer = 0;
            enemyIndex++;
        }
    }
}

-(void) randomNext:(NSMutableArray*)enemies{
	if([self hasMoreEnemies]){
        if(waitTimer <= 0){
            TDEnemy * enemy = [TDEnemy newEnemy: arc4random() % ((level / 2) + 1) % 4 move:1.6 health:40+(level * 10) inMainView:mview path:path pauseTime:10];
            [enemies addObject: enemy];
            [enemy release];
            waitTimer = max(10 - level, 0);
            enemyIndex++;
        }
        generatorTimer++;
        waitTimer--;
        if(generatorTimer == 20 * level){
            generatorTimer = 0;
            level++;
        }
	}
}

-(void) next:(NSMutableArray*)enemies{
    if(self.enemyData == NULL){
        [self randomNext:enemies];
    }else{
        [self determinedNext:enemies];
    }
}


-(bool) hasMoreEnemies{
    return enemyIndex < [self numTotalEnemies];
}

-(int) numTotalEnemies{
    if(self.enemyData == NULL)
        return NUM_ENEMIES;
    return enemyData.count;
}

-(int) getLevel{
	return level;
}

@end
