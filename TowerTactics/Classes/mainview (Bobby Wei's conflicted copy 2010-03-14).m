//
//  Final_ProjectViewController.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/7/10.
//  Copyright Stanford 2010. All rights reserved.
//

#import "mainview.h"
#import "TDRunLoop.h"
#include "ConvenienceMethods.h"
#import "TDEnemy.h"
#import "TDTower.h"

@implementation mainview

-(void) drawBackGround{
	path = [[TDPath alloc] initWithPList:@"reverseDefault"];
	
	for(int i = 0; i< 12; i++)
		for(int j = 0; j < 8; j++)
			isPath[i][j] = FALSE;
	NSArray * cells = [path getCells];
	cell * last = [cells objectAtIndex:0];
	for(int i = 1; i < [cells count]; i++ ){
		cell * current = [cells objectAtIndex:i];
		if(current.row == last.row){
			for(int i = min(current.col, last.col); i <=max(current.col, last.col); i++) 
				isPath[last.row][i] = TRUE;
		}else{
			for(int i = min(current.row, last.row); i <=max(current.row, last.row); i++) 
				isPath[i][last.col] = TRUE;
		}
			
		last = current;
	}
	for(int i =0; i < 8; i ++){
		for( int j = 0; j < 11; j ++){
			UIImage * image;
			if(!isPath[j][i]){
				int random = arc4random() % 3;
				image = [ UIImage imageNamed:
						 [NSString stringWithFormat:@"grass%d.png", random]];
			}else {
				image = [ UIImage imageNamed:@"path.png"];
			}
			UIImageView * iv = [[UIImageView alloc] initWithImage:image];
			[iv setFrame: CGRectMake(i*40, j*40, 40, 40)];
			[self.view addSubview:iv];
			[self.view bringSubviewToFront:iv];
			[iv release];
		}
	}
	UIImage * image = [UIImage imageNamed:@"statusbar.png"];
	UIImageView * iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(0, 440, 320, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
	for(int i = 0; i < 5; i++){
		image = [UIImage imageNamed:[NSString stringWithFormat:@"t%d-0.png", i]];
		UIImageView * iv = [[UIImageView alloc] initWithImage:image];
		[iv setFrame: CGRectMake(i*40, 440, 40, 40)];
		[self.view addSubview:iv];
		[self.view bringSubviewToFront:iv];
		[iv release];
	}
	image = [UIImage imageNamed:@"play.png"];
	iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(5*40, 440, 40, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
	image = [UIImage imageNamed:@"upgrade.png"];
	iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(6*40, 440, 40, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
	image = [UIImage imageNamed:@"sell.png"];
	iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(7*40, 440, 40, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self drawBackGround];
		TDRunLoop * mainRun = [[TDRunLoop alloc] initWithMV:self];
		[mainRun run:path];
    }
	[self initializeVariables];
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	int col = gridSnap((int) [[touches anyObject] locationInView:self.view].x);
	int row = gridSnap((int) [[touches anyObject] locationInView:self.view].y);			   
	if (row == 11) {
		if (col < 5)
			towerSelected = col;
			sellingMode = NO;
		if (col == 5)
			NSLog(@"Play/paused!");
		if (col == 6)
			NSLog(@"Level up!");
		if (col == 7) {
			sellingMode = YES;
		}
	} else { // Add tower
		if (hasTower[col][row] == NO && !isPath[row][col] && sellingMode == NO) {
			[self addTower:col withRow:row];
		} else if (sellingMode == YES && hasTower[col][row] == YES) {
			[self sellTower:col withRow:row];
		}
	}
	NSLog(@"%d", towerSelected);
}

- (void)addTower:(int)col withRow:(int)row {
	TDTower *newTower = [[TDTower alloc] initWithMainView:self towerType:towerSelected towerLevel:currentLevel column:col row:row];
	hasTower[col][row] = YES;
	towerGrid[col][row] = newTower;
//	[newTower release]; ADDING THIS LINE PRODUCES AN ERROR
}

- (void)sellTower:(int)col withRow:(int)row {
	TDTower *currentTower = towerGrid[col][row];
	[currentTower removeFromSuperview];
	towerGrid[col][row] = nil;
	// [towerGrid[col][row] release
	hasTower[col][row] = NO;
}

- (void)initializeVariables {
	towerSelected = 0; // Default tower
	currentLevel = 0; // Starting level
	sellingMode = false;
	for (int col = 0; col < 8; col++) {
		for (int row = 0; row < 10; row++) {
			hasTower[col][row] = NO;
		}
	}
	for (int col = 0; col < 8; col++) {
		for (int row = 0; row < 10; row++) {
			towerGrid[col][row] = nil;
		}
	}
}


- (void)dealloc {
	[path release];
    [super dealloc];
}

@end
