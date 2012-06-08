//
//  TestPuzzleViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/13/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayPuzzleViewController.h"


@interface TestPuzzleViewController : PlayPuzzleViewController

- (id)initWithSetup:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData;

@end
