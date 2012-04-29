//
//  ChessBoardViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessPieces.h"


@interface ChessBoardViewController : UIViewController

@property (nonatomic, readwrite, assign) BOOL inEditingMode;

- (id)initWithColor:(Color)newColor;

@end
