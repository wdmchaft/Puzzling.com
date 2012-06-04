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

#pragma mark - App
- (void)createApp:(NSString *)name onCompletion:(PuzzleOnCompletionBlock)onCompletion{
    [self.operationManager createApp:name onCompletion:onCompletion];
}

#pragma mark - Puzzles

- (void)getPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager getPuzzleForID:puzzleID onCompletion:onCompletion];
}

- (void)getPuzzleForCurrentUserOnCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager getPuzzleForCurrentUserOnCompletion:onCompletion];
}

- (void)createPuzzleWithType:(NSString *)type name:(NSString *)name setupData:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData isUpdate:(PuzzleID *)puzzleID onCompletionBlock:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager createPuzzleWithType:type name:name setupData:setupData solutionData:solutionData isUpdate:puzzleID onCompletionBlock:onCompletion];
}

- (void)takePuzzle:(PuzzleID *)puzzleID score:(float)score rated:(BOOL)rated onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager takePuzzle:puzzleID score:score rated:rated onCompletion:onCompletion];
}

- (void)getPuzzlesMadeByUser:(PuzzleID *)userID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[self.operationManager getPuzzlesMadeByUser:userID onCompletion:onCompletion];
}

- (void)deletePuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager deletePuzzle:puzzleID onCompletion:onCompletion];
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

#pragma mark - Leaderboards

- (void)getLeaderboardForUsersOnCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager getLeaderboardForUsersOnCompletion:onCompletion];
}

- (void)addComment:(NSString *)comment toPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager addComment:comment toPuzzle:puzzleID onCompletion:onCompletion];
}

- (void)getCommentsForPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager getCommentsForPuzzle:puzzleID onCompletion:onCompletion];
}

#pragma mark - Flagging

- (void)getFlaggedPuzzlesOnCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager getFlaggedPuzzlesOnCompletion:onCompletion];
}

- (void)flagPuzzleForRemoval:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager flagPuzzleForRemoval:puzzleID onCompletion:onCompletion];
}

- (void)deflagPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager deflagPuzzle:puzzleID onCompletion:onCompletion];
}

#pragma mark - Likes

- (void)dislikePuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager likeDislikePuzzle:puzzleID like:NO onCompletion:onCompletion];
}

- (void)likePuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	[self.operationManager likeDislikePuzzle:puzzleID like:YES onCompletion:onCompletion];
}

@end
