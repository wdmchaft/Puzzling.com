//
//  LeaderboardPuzzlesOperation.h
//  ChessTactics
//
//  Created by Peter Livesey on 6/3/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleOperation.h"


@interface LeaderboardPuzzlesOperation : PuzzleOperation

- (id)initWithRating:(BOOL)forRatings onCompletionBlock:(PuzzleOnCompletionBlock)onCompletionBlock;

@end
