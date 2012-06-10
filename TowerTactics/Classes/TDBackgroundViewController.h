//
//  TDBackgroundViewController.h
//  TowerTactics
//
//  Created by Jonathan Tilley on 5/8/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cell.h"
#define NUM_ROWS 11
#define NUM_COLS 8

@interface TDBackgroundViewController : UIViewController{
    BOOL isPath[NUM_ROWS][NUM_COLS];  // currently [row][col]
}

-(void)touchAtRow:(int)row Col:(int)col;
-(void) drawBackground;
-(void) setupPathWithCells:(NSArray*)cells;
@end
