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
#import "GetPuzzleForUserOperation.h"
#import "TakePuzzleOperation.h"
#import "GetAuthTokenForUserOperation.h"
#import "DeleteUserOperation.h"
#import "CreateUserOperation.h"


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

#pragma mark - Puzzles

- (void)getPuzzleForID:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetPuzzleOperation * operation = [[GetPuzzleOperation alloc] initWithPuzzleID:puzzleID onCompletionBlock:onCompletion delegate:self];
	[self.queue addOperation:operation];
	[operation release];
}

- (void)createPuzzleWithType:(NSString *)type setupData:(NSDictionary *)setupData solutionData:(NSDictionary*)solutionData onCompletionBlock:(PuzzleOnCompletionBlock)block {
	CreatePuzzleOperation *op = [[CreatePuzzleOperation alloc] initWithType:type setupData:setupData solutionData:solutionData puzzleType:type onCompletionBlock:block];
	[self.queue addOperation:op];
	[op release];
}

- (void)getPuzzleForCurrentUserOnCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetPuzzleForUserOperation *op = [[GetPuzzleForUserOperation alloc] initWithOnCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)takePuzzle:(PuzzleID *)puzzleID score:(float)score rated:(BOOL)rated onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	TakePuzzleOperation *op = [[TakePuzzleOperation alloc] initWithPuzzleID:puzzleID score:score rated:rated onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

#pragma mark - Login

- (void)loginUserWithUsername:(NSString *)username password:(NSString *)password onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetAuthTokenForUserOperation *op = [[GetAuthTokenForUserOperation alloc] initWithUserName:username password:password onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)deleteUser:(NSString *)username onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	DeleteUserOperation *op = [[DeleteUserOperation alloc] initWithUserName:username onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)createUser:(NSString *)username password:(NSString *)password userData:(NSDictionary *)data onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	CreateUserOperation *op = [[CreateUserOperation alloc] initWithUserName:username password:password userData:data onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

@end
