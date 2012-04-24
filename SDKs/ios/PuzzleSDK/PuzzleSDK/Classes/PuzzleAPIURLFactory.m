//
//  PuzzleAPIURLFactory.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleAPIURLFactory.h"
#define ROOT "http://localhost"

@implementation PuzzleAPIURLFactory

+ (NSURL*)urlForGetPuzzle:(NSString*)puzzleID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/%@",ROOT,puzzleID]];
}


@end
