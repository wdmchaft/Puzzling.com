//
//  PuzzleOperationManager.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperationManager.h"
#import "GetPuzzleOperation.h"


@interface PuzzleOperationManager() <NSURLConnectionDelegate> {
    NSOperationQueue *puzzle_queue;
}

@property (nonatomic, readwrite, retain) NSOperationQueue *queue;

@end

@implementation PuzzleOperationManager

@synthesize queue = puzzle_queue;

- (id)init {
    self = [super init];
    if (self) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
    }
    return self;
}

- (void)getPuzzleForID:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetPuzzleOperation * operation = [[GetPuzzleOperation alloc] initWithPuzzleID:puzzleID onCompletionBlock:onCompletion delegate:self];
	[self.queue addOperation:operation];
}

@end
