//
//  Pawn.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "Pawn.h"
#import "Coordinate.h"


@implementation Pawn

@synthesize promoted, enPassentEnabledLeft, enPassentEnabledRight;

- (id)init {
	self = [super init];
	if (self) {
		self.promoted = NO;
		self.enPassentEnabledLeft = NO;
		self.enPassentEnabledRight = NO;
	}
	return self;
}

- (NSString*)imageName {
    if (self.promoted) {
		return self.color==kWhite?@"wq.png":@"bq.png";
	} else {
		return self.color==kWhite?@"wp.png":@"bp.png";
	}
}

- (MovementVectors*)movementVectors {
	MovementVectors * movementVectors = [[[MovementVectors alloc] init] autorelease];
	if (self.promoted) {
		[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:0] autorelease]];
		[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:0 Y:-1] autorelease]];
		[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:0 Y:1] autorelease]];
		[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:0] autorelease]];
		[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:1] autorelease]];
		[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:-1] autorelease]];
		[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:1] autorelease]];
		[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:-1] autorelease]];
		movementVectors.infiniteMovement = YES;
	} else {
		//Logic handled in model
		movementVectors.infiniteMovement = NO;
	}
	return movementVectors;
}

@end
