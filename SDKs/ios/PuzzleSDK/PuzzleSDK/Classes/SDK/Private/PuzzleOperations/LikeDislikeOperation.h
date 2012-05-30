//
//  LikeDislikeOperation.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleOperation.h"

@interface LikeDislikeOperation : PuzzleOperation

- (id)initWithPuzzleID:(PuzzleID *)puzzleID isLike:(BOOL)like onCompletion:(PuzzleOnCompletionBlock)block;

@end
