//
//  ChessMove.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/29/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "ChessMove.h"

@implementation ChessMove

@synthesize start;
@synthesize finish;
@synthesize promotionType;

- (void)dealloc {
	[start release];
	start = nil;
	[finish release];
	finish = nil;
	[promotionType release];
	promotionType = nil;
	
	[super dealloc];
}

@end
