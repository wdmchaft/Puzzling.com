//
//  PuzzleDownloader.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/5/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleDownloader.h"
#import "PuzzleSDK.h"

@implementation PuzzleDownloader

static PuzzleDownloader *sharedInstance;

+ (PuzzleDownloader *)sharedInstance {
	if (!sharedInstance) {
		sharedInstance = [[PuzzleDownloader alloc] init];
	}
	return sharedInstance;
}

- (void)downloadPuzzleWithCallback:(void(^)(PuzzlePuzzle *))block {
	[[PuzzleSDK sharedInstance] getPuzzleForCurrentUserOnCompletion:^(PuzzleAPIResponse response, id data) {
		block(data);
	}];
}

@end
