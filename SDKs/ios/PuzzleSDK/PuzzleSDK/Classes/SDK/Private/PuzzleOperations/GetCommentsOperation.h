//
//  GetCommentsOperation.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/23/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "PuzzleOperation.h"

@interface GetCommentsOperation : PuzzleOperation

- (id)initWithPuzzleID:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)block;

@end
