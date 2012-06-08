//
//  King.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "King.h"
#import "Coordinate.h"

@implementation King

- (NSString*)imageName {
	return self.color==kWhite?@"wk.png":@"bk.png";
}

- (MovementVectors*)movementVectors {
	MovementVectors * movementVectors = [[[MovementVectors alloc] init] autorelease];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:0] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:0 Y:-1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:0 Y:1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:0] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:-1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:-1] autorelease]];
	movementVectors.infiniteMovement = NO;
	return movementVectors;
}

@end
