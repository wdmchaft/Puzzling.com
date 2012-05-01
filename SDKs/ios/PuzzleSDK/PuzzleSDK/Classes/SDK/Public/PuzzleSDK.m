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

- (void)getPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager getPuzzleForID:puzzleID onCompletion:onCompletion];
}

- (void)createPuzzleWithType:(NSString *)type setupData:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData onCompletionBlock:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager createPuzzleWithType:type setupData:setupData solutionData:solutionData onCompletionBlock:onCompletion];
}

@end
