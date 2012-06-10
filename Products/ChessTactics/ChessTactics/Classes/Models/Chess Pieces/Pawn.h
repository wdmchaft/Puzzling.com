//
//  Pawn.h
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChessPiece.h"


@interface Pawn : ChessPiece

@property (nonatomic, assign) BOOL promoted;
@property (nonatomic, assign) BOOL enPassentEnabledLeft;
@property (nonatomic, assign) BOOL enPassentEnabledRight;

@end
