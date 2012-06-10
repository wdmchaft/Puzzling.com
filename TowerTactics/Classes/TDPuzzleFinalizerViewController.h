//
//  TDPuzzleFinalizer.h
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/3/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//


#include "TDPuzzleCreationPane.h"

@interface TDPuzzleFinalizerViewController : TDPuzzleCreationPane
@property (nonatomic, retain) NSArray* enemies;
@property (nonatomic, retain) NSArray* cells;
@property (nonatomic, retain) IBOutlet UITextField* name;
@property (nonatomic, retain) IBOutlet UISlider* slider;
@property (nonatomic, retain) IBOutlet UILabel* moneyLabel;


-(IBAction)textEntered;
-(IBAction)sliderMoved:(id)sender;
@end
