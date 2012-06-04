//
//  PuzzleOperationManager.h
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleSDK.h"


@interface PuzzleOperationManager : NSObject

//Puzzles
- (void)getPuzzleForID:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)createPuzzleWithType:(NSString *)type name:(NSString *)name setupData:(NSDictionary *)setupData solutionData:(NSDictionary*)solutionData isUpdate:(PuzzleID *)puzzleID onCompletionBlock:(PuzzleOnCompletionBlock)block;

- (void)getPuzzleForCurrentUserOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)takePuzzle:(PuzzleID *)puzzleID score:(float)score rated:(BOOL)rated onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)getPuzzlesMadeByUser:(PuzzleID *)userID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)deletePuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

//Login
- (void)loginUserWithUsername:(NSString *)username password:(NSString *)password onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)createUser:(NSString *)username password:(NSString *)password userData:(NSDictionary *)data onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)deleteUser:(NSString *)username onCompletion:(PuzzleOnCompletionBlock)onCompletion;

#pragma mark - Leaderboard
- (void)getLeaderboardForUsersOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)getLeaderboardForPuzzlesRatingOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)getLeaderboardForPuzzlesLikesOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

#pragma mark - Comments
- (void)addComment:(NSString *)comment toPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)getCommentsForPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

#pragma mark - Flagging

- (void)getFlaggedPuzzlesOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)flagPuzzleForRemoval:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)deflagPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

#pragma mark - Like/Dislike

- (void)likeDislikePuzzle:(PuzzleID *)puzzleID like:(BOOL)like onCompletion:(PuzzleOnCompletionBlock)onCompletion;

@end
