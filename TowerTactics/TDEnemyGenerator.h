//
//  TDEnemyGenerator.h
//  Final Project
//
//  Created by Jonathan Tilley on 3/13/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mainview.h"
#import "TDPath.h"

@interface TDEnemyGenerator : NSObject {
	int level;
	int generatorTimer;
	int waitTimer;
	mainview * mview;
	TDPath* path;
    NSArray* enemyData;
    int enemyIndex;
}

@property (nonatomic,retain,readwrite) NSArray* enemyData;
-(id) initWithMV:(mainview*)mv path:(TDPath*) p enemyData:(NSArray*)data;
-(void) next:(NSMutableArray *) enemies;
-(int) getLevel;
-(bool) hasMoreEnemies;
-(int) numTotalEnemies;


@end
