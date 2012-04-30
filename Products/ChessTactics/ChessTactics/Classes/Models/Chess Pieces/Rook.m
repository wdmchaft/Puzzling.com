//
//  Rook.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "Rook.h"
#import "Coordinate.h"


@implementation Rook

- (NSString*)imageName {
	return self.color==kWhite?@"wr.png":@"br.png";
}

- (MovementVectors*)movementVectors {
	MovementVectors * movementVectors = [[[MovementVectors alloc] init] autorelease];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:0] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:0 Y:-1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:0 Y:1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:0] autorelease]];
	movementVectors.infiniteMovement = YES;
	return movementVectors;
}

@end
