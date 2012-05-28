//
//  PuzzleParsingHelpers.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/26/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleParsingHelpers.h"
#import "PuzzleModel.h"
#import "JSONKit.h"


@implementation PuzzleParsingHelpers

+ (PuzzleModel *)parseDictionary:(NSDictionary *)data
{
	PuzzleModel *puzzle = [[[PuzzleModel alloc] init] autorelease];
	puzzle.creatorID = [data objectForKey:@"creator"];
	puzzle.dislikes = [[data objectForKey:@"dislikes"] intValue];
	puzzle.likes = [[data objectForKey:@"likes"] intValue];
	puzzle.rating = [[data objectForKey:@"rating"] doubleValue] + .5;
	puzzle.taken = [[data objectForKey:@"taken"] intValue];
	puzzle.timeCreated = [data objectForKey:@"timestamp"];
    puzzle.setupData = [[data objectForKey:@"setupData"] objectFromJSONString];
    puzzle.solutionData = [[data objectForKey:@"solutionData"] objectFromJSONString];
    puzzle.type = [data objectForKey:@"type"];
    puzzle.puzzleID = [data objectForKey:@"_id"];
	puzzle.name = [data objectForKey:@"name"];
	puzzle.removed = [[data objectForKey:@"removed"] boolValue];
	puzzle.flagged = [[data objectForKey:@"flaggedForRemoval"] boolValue];
	
	return puzzle;
}

@end
