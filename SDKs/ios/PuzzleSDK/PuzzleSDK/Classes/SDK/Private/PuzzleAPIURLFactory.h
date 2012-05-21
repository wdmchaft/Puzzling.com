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
+ (NSURL*)urlForGetAuthTokenForUser;
+ (NSURL*)urlForDeleteUser;
+ (NSURL*)urlForCreatePuzzle;
+ (NSURL*)urlForGetPuzzleForUser;
+ (NSURL*)urlForGetPuzzlesMadeByUser:(PuzzleID *)userID;
+ (NSURL*)urlForTakenPuzzle:(NSString*)puzzleID rated:(BOOL)rated;

@end
