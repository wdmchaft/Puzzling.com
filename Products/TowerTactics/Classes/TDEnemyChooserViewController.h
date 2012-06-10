//
//  TDEnemyChooserViewController.h
//  TowerTactics
//
//  Created by Jonathan Tilley on 5/19/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDBackgroundViewController.h"
#import "TDPuzzleCreationPane.h"

@interface TDEnemyChooserViewController : TDPuzzleCreationPane <UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel * pauseTimeLabel;
@property (nonatomic, retain) IBOutlet UISlider * pauseTimeSlider;
@property (nonatomic, retain) IBOutlet UITableView * enemyTable;

@property (nonatomic, retain) IBOutlet UISegmentedControl * selectedEnemy;

@property (nonatomic,retain) NSMutableArray* enemies;

-(IBAction)sliderMoved:(id)sender;



@end
