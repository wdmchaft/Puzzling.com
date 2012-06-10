//
//  DeflagPuzzleOperation.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/26/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "PuzzleOperation.h"

@interface DeflagPuzzleOperation : PuzzleOperation

- (id)initWithPuzzleID:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)block;

@end
