//
//  ChessBoardView.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "ChessBoardView.h"

@implementation ChessBoardView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		double squareSize = self.frame.size.height / 8;
		
		for (int x = 0; x<8; x++) {
			for (int y = 0; y<8; y++) {
				UIImage *squareImage = nil;
				if ((x+y)%2 == 0) {
					squareImage = [UIImage imageNamed:@"lightWoodSquare"];
				} else {
					squareImage = [UIImage imageNamed:@"darkWoodSquare"];
				}
				UIImageView *square = [[[UIImageView alloc] initWithImage:squareImage] autorelease];
				square.frame = CGRectMake(squareSize * x, squareSize * y, squareSize, squareSize);
				[self addSubview:square];
			}
		}
	}
	return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//	
//	double squareSize = self.frame.size.height / 8;
//	
//	for (int x = 0; x<8; x++) {
//		for (int y = 0; y<8; y++) {
//			if ((x+y)%2 == 0) {
//				//CGContextSetRGBFillColor(context, 250.0/255, 235.0/255, 215.0/255, 1);
//			} else {
//				//CGContextSetRGBFillColor(context, 210.0/255, 105.0/255, 30.0/255, 1);
//			}
////			CGContextFillRect(context, CGRectMake(x*squareSize, y*squareSize, squareSize, squareSize));
//		}
//	}
//}


@end
