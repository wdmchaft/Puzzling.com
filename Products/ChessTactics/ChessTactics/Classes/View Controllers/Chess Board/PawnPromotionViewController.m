//
//  PawnPromotionViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/6/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PawnPromotionViewController.h"
#import "ChessPieces.h"


@interface PawnPromotionViewController () {
	id<PawnPromotionDelegate> __delegate;
}

@end

@implementation PawnPromotionViewController

@synthesize delegate = __delegate;

- (IBAction)queenChosen {
	if ([self.delegate respondsToSelector:@selector(pawnPromotionViewController:didSelectClass:)]) {
		[self.delegate pawnPromotionViewController:self didSelectClass:[Queen class]];
	}
}

- (IBAction)bishopChosen {
	if ([self.delegate respondsToSelector:@selector(pawnPromotionViewController:didSelectClass:)]) {
		[self.delegate pawnPromotionViewController:self didSelectClass:[Bishop class]];
	}
}

- (IBAction)knightChosen {
	if ([self.delegate respondsToSelector:@selector(pawnPromotionViewController:didSelectClass:)]) {
		[self.delegate pawnPromotionViewController:self didSelectClass:[Knight class]];
	}
}

- (IBAction)rookChosen {
	if ([self.delegate respondsToSelector:@selector(pawnPromotionViewController:didSelectClass:)]) {
		[self.delegate pawnPromotionViewController:self didSelectClass:[Rook class]];
	}
}

- (void)dealloc {
	[super dealloc];
}

@end
