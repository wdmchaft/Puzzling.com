//
//  CreatePuzzleViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "CreatePuzzleViewController.h"
#import "ChessBoardViewController.h"


@interface CreatePuzzleViewController () {
	ChessBoardViewController *__chessBoardViewController;
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;

@end

@implementation CreatePuzzleViewController

@synthesize chessBoardViewController = __chessBoardViewController;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.chessBoardViewController = [[[ChessBoardViewController alloc] init] autorelease];
	self.chessBoardViewController.inEditingMode = YES;
	[self.view addSubview:self.chessBoardViewController.view];
}

@end
