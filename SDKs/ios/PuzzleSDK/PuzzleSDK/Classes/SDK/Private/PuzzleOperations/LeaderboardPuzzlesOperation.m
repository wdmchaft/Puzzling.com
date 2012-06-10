//
//  LeaderboardPuzzlesOperation.m
//  ChessTactics
//
//  Created by Peter Livesey on 6/3/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "LeaderboardPuzzlesOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "PuzzleUser.h"
#import "JSONKit.h"
#import "PuzzleParsingHelpers.h"


@interface LeaderboardPuzzlesOperation() {
	BOOL puzzle_rating;
}

@property (nonatomic, readwrite, assign) BOOL rating;

@end

@implementation LeaderboardPuzzlesOperation

@synthesize rating = puzzle_rating;

- (id)initWithRating:(BOOL)forRatings onCompletionBlock:(PuzzleOnCompletionBlock)onCompletionBlock
{
	self = [super initWithOnCompletionBlock:onCompletionBlock];
	if (self)
	{
		self.rating = forRatings;
	}
	return self;
}

- (NSURL *)url {
    if (self.rating)
	{
		return [PuzzleAPIURLFactory urlForLeaderboardPuzzleRating];
	}
	else
	{
		return [PuzzleAPIURLFactory urlForLeaderboardPuzzleLikes];
	}
}

- (void)runCompletionBlock{
    NSMutableArray *puzzles = [NSMutableArray array];
    
    NSArray* data = [self.data objectFromJSONData];
    for (NSDictionary *puzzleData in data)
	{
		PuzzleModel *puzzle = [PuzzleParsingHelpers parseDictionary:puzzleData];
		[puzzles addObject:puzzle];
	}
	
    self.onCompletion(self.response, puzzles); 
}

@end
