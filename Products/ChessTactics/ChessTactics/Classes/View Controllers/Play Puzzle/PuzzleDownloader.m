//
//  PuzzleDownloader.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/5/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleDownloader.h"
#import "PuzzleSDK.h"


#define MAX_CACHED_PUZZLES 3

@interface PuzzleDownloader() {
	NSMutableArray *__puzzles;
}

@property (nonatomic, readonly, retain) NSMutableArray *puzzles;

- (void)downloadMorePuzzles;

@end

@implementation PuzzleDownloader

static PuzzleDownloader *sharedInstance;

+ (PuzzleDownloader *)sharedInstance {
	if (!sharedInstance) {
		sharedInstance = [[PuzzleDownloader alloc] init];
	}
	return sharedInstance;
}

- (void)downloadMorePuzzles {
	if ([self.puzzles count] < MAX_CACHED_PUZZLES) {
		[[PuzzleSDK sharedInstance] getPuzzleForCurrentUserOnCompletion:^(PuzzleAPIResponse response, id data) {
			if (response == PuzzleOperationSuccessful) {
				[self.puzzles addObject:data];
				[self downloadMorePuzzles];
			} else {
				[PuzzleErrorHandler presentErrorForResponse:response];
			}
		}];
	}
}

// If we ever get tactic with id not equal to...
- (void)downloadPuzzleWithCallback:(void(^)(PuzzleAPIResponse, PuzzleModel *))block {
//	if ([self.puzzles count] > 0) {
//		PuzzleModel *puzzle = [self.puzzles objectAtIndex:0];
//		block(PuzzleOperationSuccessful, puzzle);
//		[self.puzzles removeObjectAtIndex:0];
//	}
	[[PuzzleSDK sharedInstance] getPuzzleForCurrentUserOnCompletion:^(PuzzleAPIResponse response, id data) {
		if (response == PuzzleOperationSuccessful) {
			block(response, data);
		} else {
			[PuzzleErrorHandler presentErrorForResponse:response];
		}
	}];
//	[self downloadMorePuzzles];
}

#pragma mark - Properties

- (NSMutableArray *)puzzles {
	if (!__puzzles) {
		__puzzles = [[NSMutableArray arrayWithCapacity:MAX_CACHED_PUZZLES] retain];
	}
	return __puzzles;
}

@end
