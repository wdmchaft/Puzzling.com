//
//  Bishop.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "Bishop.h"
#import "Coordinate.h"


@implementation Bishop

- (NSString*)imageName {
	return self.color==kWhite?@"wb.png":@"bb.png";
}

- (MovementVectors*)movementVectors {
	MovementVectors * movementVectors = [[[MovementVectors alloc] init] autorelease];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:1 Y:-1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:1] autorelease]];
	[movementVectors.vectors addObject:[[[Coordinate alloc] initWithX:-1 Y:-1] autorelease]];
	movementVectors.infiniteMovement = YES;
	return movementVectors;
}

@end
