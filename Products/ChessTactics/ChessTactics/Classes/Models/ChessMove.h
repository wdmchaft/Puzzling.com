//
//  ChessMove.h
//  ChessTactics
//
//  Created by Peter Livesey on 4/29/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"


@interface ChessMove : NSObject

@property (nonatomic, readwrite, retain) Coordinate *start;
@property (nonatomic, readwrite, retain) Coordinate *finish;
@property (nonatomic, readwrite, retain) NSString *promotionType;

@end
