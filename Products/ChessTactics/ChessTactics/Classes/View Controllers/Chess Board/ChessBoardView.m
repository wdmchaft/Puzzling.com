//
//  ChessBoardView.m
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "ChessBoardView.h"

@implementation ChessBoardView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	double squareSize = self.frame.size.height / 8;
	
	for (int x = 0; x<8; x++) {
		for (int y = 0; y<8; y++) {
			if ((x+y)%2 == 0) {
				CGContextSetRGBFillColor(context, 250.0/255, 235.0/255, 215.0/255, 1);
			} else {
				CGContextSetRGBFillColor(context, 210.0/255, 105.0/255, 30.0/255, 1);
			}
			CGContextFillRect(context, CGRectMake(x*squareSize, y*squareSize, squareSize, squareSize));
		}
	}
}


@end
