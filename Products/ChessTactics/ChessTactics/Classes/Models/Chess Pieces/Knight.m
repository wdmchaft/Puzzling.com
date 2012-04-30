//
//  Knight.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "Knight.h"
#import "Coordinate.h"


@implementation Knight

- (NSString*)imageName {
	return self.color==kWhite?@"wn.png":@"bn.png";
}

- (MovementVectors*)movementVectors {
	MovementVectors * movementVectors = [[[MovementVectors alloc] init] autorelease];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:2] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:2] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:-2] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:-2] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:2 Y:1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-2 Y:1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:2 Y:-1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-2 Y:-1] autorelease]];
	movementVectors.infiniteMovement = NO;
	return movementVectors;
}

@end
