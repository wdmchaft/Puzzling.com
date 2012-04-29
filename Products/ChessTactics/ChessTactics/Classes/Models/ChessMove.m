//
//  ChessMove.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/29/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "ChessMove.h"

@implementation ChessMove

@synthesize start;
@synthesize finish;

- (void)dealloc {
	[start release];
	start = nil;
	[finish release];
	finish = nil;
	
	[super dealloc];
}

@end
