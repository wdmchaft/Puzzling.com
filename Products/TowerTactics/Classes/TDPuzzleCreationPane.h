//
//  TDPuzzleCreationPane.h
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/3/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//



@interface TDPuzzleCreationPane : UIViewController
@property (nonatomic, retain) UIViewController *introPage;
@property (nonatomic, retain) UIViewController *nextPage;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;



-(IBAction)next;
-(IBAction)back;
@end
