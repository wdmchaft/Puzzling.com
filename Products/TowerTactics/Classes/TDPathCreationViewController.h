//
//  TDPuzzleCreationViewController.h
//  TowerTactics
//
//  Created by Jonathan Tilley on 5/8/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDBackgroundViewController.h"
#import "cell.h"

@interface TDPathCreationViewController : TDBackgroundViewController{
    bool allowsSelection[NUM_ROWS][NUM_COLS];
    Cell* curSelection;
    NSMutableArray* cells;
    NSArray* savedViews;
}
@property (nonatomic,retain) NSMutableArray* enemies;
@property (nonatomic, retain) UIViewController *introPage;
@property (nonatomic, retain) UIViewController *nextPage;

@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *testButton;

-(IBAction)next;
-(IBAction)back;
-(IBAction)test;

-(bool) nextShouldBeEnabled;

@end
