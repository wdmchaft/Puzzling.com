//
//  PuzzleAPIURLFactory.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleAPIURLFactory.h"
//#define ROOT_API_URL @"http://localhost:3000"
#define ROOT_API_URL @"https://ec2-184-169-151-249.us-west-1.compute.amazonaws.com"

@implementation PuzzleAPIURLFactory

+ (NSURL*)urlForGetPuzzle:(NSString*)puzzleID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/%@",ROOT_API_URL,puzzleID]];
}
+ (NSURL*)urlForCreateUser{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/login",ROOT_API_URL]];
}
+ (NSURL*)urlForCreateApp{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/papp",ROOT_API_URL]];
}
+ (NSURL*)urlForGetAuthTokenForUser:(NSString *)username password:(NSString *)password
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/login?username=%@&password=%@",ROOT_API_URL, username, password]];
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
+ (NSURL*)urlForGetPuzzlesMadeByUser:(PuzzleID *)userID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/user/%@",ROOT_API_URL,userID]];
}
+ (NSURL*)urlForTakenPuzzle:(NSString*)puzzleID rated:(BOOL)rated {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/%@?notRated=%@",ROOT_API_URL,puzzleID, rated?@"false":@"true"]];
}
+ (NSURL*)urlForUserLeaderboard
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/leaderboard/user",ROOT_API_URL]];
}
+ (NSURL*)urlForComment:(PuzzleID *)puzzleID
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/comment/%@",ROOT_API_URL,puzzleID]];
}
+ (NSURL*)urlForFlagForRemoval:(PuzzleID *)puzzleID
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/flag/%@",ROOT_API_URL,puzzleID]];
}
+ (NSURL*)urlForGetFlagged
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/flag",ROOT_API_URL]];
}
+ (NSURL*)urlForDeletePuzzle
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle",ROOT_API_URL]];
}
+ (NSURL*)urlForDeflagPuzzle:(PuzzleID *)puzzleID
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/deflag/%@",ROOT_API_URL,puzzleID]];
}
+ (NSURL*)urlForUpdatePuzzle
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzle/update",ROOT_API_URL]];
}
+ (NSURL*)urlForLikePuzzle
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/like",ROOT_API_URL]];
}
+ (NSURL*)urlForDislikePuzzle
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/dislike",ROOT_API_URL]];
}

@end
