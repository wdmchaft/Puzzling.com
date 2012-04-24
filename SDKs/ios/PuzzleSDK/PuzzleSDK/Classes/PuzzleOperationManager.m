//
//  PuzzleOperationManager.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperationManager.h"
#import "GetPuzzleOperation.h"


@interface PuzzleOperationManager() <PuzzleOperationDelegate> {
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

- (void)getPuzzleForID:(PuzzleID *)puzzleID {
	GetPuzzleOperation * operation = [[GetPuzzleOperation alloc] initWithPuzzleID:@"4f9204c648a71e7312000003" delegate:self];
	[self.queue addOperation:operation];
}

@end
