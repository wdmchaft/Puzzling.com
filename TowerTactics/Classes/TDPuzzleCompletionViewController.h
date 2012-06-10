//
//  TDPuzzleCompletionViewController.h
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/5/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDPuzzleCompletionViewController : UIViewController
@property (nonatomic, assign) float score;
@property (nonatomic, retain) IBOutlet  UILabel* scoreLabel;
@property (nonatomic, retain) UIViewController* introView;

-(IBAction)dismissSelf;
@end
