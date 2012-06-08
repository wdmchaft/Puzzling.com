//
//  PuzzleComment.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/20/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "PuzzleComment.h"

@implementation PuzzleComment

@synthesize message, poster, posterID;

- (void)dealloc
{
	[message release];
	message = nil;
	[poster release];
	poster = nil;
	[posterID release];
	posterID = nil;
	
	[super dealloc];
}

@end
