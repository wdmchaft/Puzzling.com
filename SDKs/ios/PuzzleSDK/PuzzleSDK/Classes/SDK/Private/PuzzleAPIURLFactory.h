//
//  PuzzleAPIURLFactory.h
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleSDK.h"


@interface PuzzleAPIURLFactory : NSObject

+ (NSURL*)urlForGetPuzzle:(NSString*)puzzleID;
+ (NSURL*)urlForCreateUser;
+ (NSURL*)urlForGetAuthTokenForUser:(NSString *)username password:(NSString *)password;
+ (NSURL*)urlForDeleteUser;
+ (NSURL*)urlForCreatePuzzle;
+ (NSURL*)urlForGetPuzzleForUser;
+ (NSURL*)urlForGetPuzzlesMadeByUser:(PuzzleID *)userID;
+ (NSURL*)urlForTakenPuzzle:(NSString*)puzzleID rated:(BOOL)rated;
+ (NSURL*)urlForUserLeaderboard;
+ (NSURL*)urlForComment:(PuzzleID *)puzzleID;
+ (NSURL*)urlForFlagForRemoval:(PuzzleID *)puzzleID;
+ (NSURL*)urlForGetFlagged;
+ (NSURL*)urlForDeletePuzzle;
+ (NSURL*)urlForDeflagPuzzle:(PuzzleID *)puzzleID;
+ (NSURL*)urlForUpdatePuzzle;
@end
