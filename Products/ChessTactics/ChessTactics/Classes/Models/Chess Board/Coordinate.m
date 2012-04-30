//
//  Vector.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

@synthesize x,y;

- (id)initWithX:(int)xInitial Y:(int)yInitial {
	self = [super init];
	if (self) {
		self.x = xInitial;
		self.y = yInitial;
	}
	return self;
}

@end
