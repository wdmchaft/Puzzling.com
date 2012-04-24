//
//  PuzzleOperationManager.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperationManager.h"

@interface PuzzleOperationManager() {
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

//- (void)sendGetPuzzle {
//    GetPuzzleOp = init;
//    op.delegate = self;
//    [self.queue addOperation:op];
//}

@end
