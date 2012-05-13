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

- (void)createPuzzleWithType:(NSString *)type setupData:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData onCompletionBlock:(PuzzleOnCompletionBlock)onCompletion;

- (void)takePuzzle:(PuzzleID *)puzzleID score:(float)score rated:(BOOL)rated onCompletion:(PuzzleOnCompletionBlock)onCompletion;

//Login
- (void)loginUserWithUsername:(NSString *)username password:(NSString *)password onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)createUser:(NSString *)username password:(NSString *)password userData:(NSDictionary *)data onCompletion:(PuzzleOnCompletionBlock)onCompletion;

- (void)deleteUser:(NSString *)username onCompletion:(PuzzleOnCompletionBlock)onCompletion;

@end
