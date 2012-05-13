//
//  TakePuzzleOperation.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"

@interface TakePuzzleOperation : PuzzleOperation

-(id)initWithPuzzleID:(PuzzleID*)puzzleID score:(float)score rated:(BOOL)rated onCompletionBlock:(PuzzleOnCompletionBlock)block;

@end
