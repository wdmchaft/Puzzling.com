//
//  ChessPiece.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "ChessPiece.h"


@implementation ChessPiece

@synthesize color;
@synthesize x,y;
@synthesize view;
@synthesize movementVectors;
@synthesize moved;

- (id)initWithColor:(Color)initialColor {
	self = [super init];
	if (self) {
		self.color = initialColor;
		self.moved = NO;
	}
	return self;
}

- (NSString*)imageName {
	return nil;
}

- (UIImageView*)view {
	if (!view) {
		view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageName]];
	}
	return view;
}

- (void)dealloc {
	self.view = nil;
	
	[super dealloc];
}

@end
