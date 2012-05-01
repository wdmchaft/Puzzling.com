//
//  PuzzleOperationManager.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperationManager.h"
#import "GetPuzzleOperation.h"
#import "CreatePuzzleOperation.h"


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
	[operation release];
}

- (void)createPuzzleWithType:(NSString *)type setupData:(NSDictionary *)setupData solutionData:(NSDictionary*)solutionData onCompletionBlock:(PuzzleOnCompletionBlock)block {
	CreatePuzzleOperation *op = [[CreatePuzzleOperation alloc] initWithType:type setupData:setupData solutionData:solutionData additionalData:nil puzzleType:type authToken:nil onCompletionBlock:block];
	[self.queue addOperation:op];
	[op release];
}

@end
