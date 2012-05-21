//
//  PuzzleSDK.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleSDK.h"
#import "PuzzleOperationManager.h"


@interface PuzzleSDK() {
	PuzzleOperationManager *puzzle_operationManager;
}

@property (nonatomic, readwrite, retain) PuzzleOperationManager *operationManager;

@end

@implementation PuzzleSDK

@synthesize operationManager = puzzle_operationManager;

#pragma mark - Singleton

PuzzleSDK * sharedInstance = nil;

+ (PuzzleSDK *)sharedInstance {
	if (sharedInstance == nil) {
		sharedInstance = [[PuzzleSDK alloc] init];
	}
	return sharedInstance;
}

#pragma mark - Properties

- (PuzzleOperationManager *)operationManager {
	if (!puzzle_operationManager) {
		puzzle_operationManager = [[PuzzleOperationManager alloc] init];
	}
	return puzzle_operationManager;
}

#pragma mark - Public Methods
#pragma mark - Puzzles

- (void)getPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager getPuzzleForID:puzzleID onCompletion:onCompletion];
}

- (void)getPuzzleForCurrentUserOnCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager getPuzzleForCurrentUserOnCompletion:onCompletion];
}

- (void)createPuzzleWithType:(NSString *)type name:(NSString *)name setupData:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData onCompletionBlock:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager createPuzzleWithType:type name:name setupData:setupData solutionData:solutionData onCompletionBlock:onCompletion];
}

- (void)takePuzzle:(PuzzleID *)puzzleID score:(float)score rated:(BOOL)rated onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager takePuzzle:puzzleID score:score rated:rated onCompletion:onCompletion];
}

- (void)getPuzzlesMadeByUser:(PuzzleID *)userID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager getPuzzlesMadeByUser:userID onCompletion:onCompletion];
}

#pragma mark - Login

- (void)loginUserWithUsername:(NSString *)username password:(NSString *)password onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager loginUserWithUsername:username password:password onCompletion:onCompletion];
}

- (void)createUser:(NSString *)username password:(NSString *)password userData:(NSDictionary *)data onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager createUser:username password:password userData:data onCompletion:onCompletion];
}

- (void)deleteUser:(NSString *)username onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager deleteUser:username onCompletion:onCompletion];
}

@end
