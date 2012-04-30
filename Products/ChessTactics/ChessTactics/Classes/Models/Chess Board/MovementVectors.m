//
//  MovementVectors.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "MovementVectors.h"

@implementation MovementVectors

@synthesize vectors, infiniteMovement;

- (NSMutableArray*)vectors {
	if (!vectors) {
		vectors = [[NSMutableArray alloc] initWithCapacity:8];
	}
	return vectors;
}

- (void)dealloc {
	self.vectors = nil;
	[super dealloc];
}

@end
