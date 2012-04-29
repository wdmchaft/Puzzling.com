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
@synthesize tag;

- (id)initWithColor:(Color)initialColor tag:(int)tagInt {
	self = [super init];
	if (self) {
		self.color = initialColor;
		self.moved = NO;
		self.tag = [NSString stringWithFormat:@"num%d", tagInt];
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
	self.tag = nil;
	
	[super dealloc];
}

@end
