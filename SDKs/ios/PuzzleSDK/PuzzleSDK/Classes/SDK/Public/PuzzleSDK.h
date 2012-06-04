//
//  PuzzleSDK.h
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleErrorHandler.h"


typedef NSString PuzzleID;

typedef void(^PuzzleOnCompletionBlock)(PuzzleAPIResponse, id);

@interface PuzzleSDK : NSObject

+ (PuzzleSDK *)sharedInstance;

//Puzzles
- (void)getPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)getPuzzleForCurrentUserOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)createPuzzleWithType:(NSString *)type name:(NSString *)name setupData:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData isUpdate:(PuzzleID *)puzzleID onCompletionBlock:(PuzzleOnCompletionBlock)onCompletion;

- (void)takePuzzle:(PuzzleID *)puzzleID score:(float)score rated:(BOOL)rated onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)getPuzzlesMadeByUser:(PuzzleID *)userID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)deletePuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

//Login
- (void)loginUserWithUsername:(NSString *)username password:(NSString *)password onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)createUser:(NSString *)username password:(NSString *)password userData:(NSDictionary *)data onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)deleteUser:(NSString *)username onCompletion:(PuzzleOnCompletionBlock)onCompletion;

//Leaderboard
- (void)getLeaderboardForUsersOnCompletion:(PuzzleOnCompletionBlock)onCompletion;
- (void)getLeaderboardForPuzzlesRatingOnCompletion:(PuzzleOnCompletionBlock)onCompletion;
- (void)getLeaderboardForPuzzlesLikesOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

//Comments
- (void)addComment:(NSString *)comment toPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)getCommentsForPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

//Flagging
- (void)getFlaggedPuzzlesOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)flagPuzzleForRemoval:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)deflagPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

//Like
- (void)dislikePuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;
- (void)likePuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

@end
