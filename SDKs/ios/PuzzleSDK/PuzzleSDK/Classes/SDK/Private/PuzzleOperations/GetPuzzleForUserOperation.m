//
//  GetPuzzleForUser.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPuzzleForUserOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"
#import "PuzzleModel.h"


@interface GetPuzzleForUserOperation() {
}
@end

@implementation GetPuzzleForUserOperation


- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"GET"];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetPuzzleForUser];
}

-(void) runCompletionBlock{
    PuzzleModel* puzzle = [[[PuzzleModel alloc] init] autorelease];
    
    NSDictionary* data = [self.data objectFromJSONData];
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
    
    self.onCompletion(self.response, puzzle); 
}

@end
