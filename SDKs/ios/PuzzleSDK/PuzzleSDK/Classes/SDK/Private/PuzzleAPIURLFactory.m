//
//  PuzzleAPIURLFactory.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleAPIURLFactory.h"
#define ROOT_API_URL @"http://localhost:3000"

@implementation PuzzleAPIURLFactory

+ (NSURL*)urlForGetPuzzle:(NSString*)puzzleID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/%@",ROOT_API_URL,puzzleID]];
}
+ (NSURL*)urlForCreateUser{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/login",ROOT_API_URL]];
}
+ (NSURL*)urlForGetAuthTokenForUser{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/login",ROOT_API_URL]];
}

+ (NSURL*)urlForDeleteUser{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/login",ROOT_API_URL]];
}
+ (NSURL*)urlForCreatePuzzle{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle",ROOT_API_URL]];
}
+ (NSURL*)urlForGetPuzzleForUser{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle",ROOT_API_URL]];
}
+ (NSURL*)urlForGetPuzzlesMadeByUser:(NSString*)username{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@",ROOT_API_URL,username]];
}
+ (NSURL*)urlForTakenPuzzle:(NSString*)puzzleID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/%@",ROOT_API_URL,puzzleID]];
}
@end
