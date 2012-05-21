//
//  GetPuzzlesMadeByUserOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPuzzlesMadeByUserOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"
#import "PuzzleModel.h"


@interface GetPuzzlesMadeByUserOperation() {
    PuzzleID *p_userID;
}
@property (nonatomic,retain,readwrite) PuzzleID *userID;
@end

@implementation GetPuzzlesMadeByUserOperation

@synthesize userID = p_userID;

-(id)initWithUserID:(PuzzleID *)userID onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.userID = userID;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"GET"];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetPuzzlesMadeByUser:self.userID];
}

-(void) runCompletionBlock{
    NSArray *data = [self.data objectFromJSONData];
	NSMutableArray *puzzles = [NSMutableArray arrayWithCapacity:[data count]];
	for (NSDictionary *puzzleDic in data) {
		PuzzleModel* puzzle = [[[PuzzleModel alloc] init] autorelease];
		puzzle.type = [puzzleDic objectForKey:@"type"];
		puzzle.puzzleID = [puzzleDic objectForKey:@"_id"];
		puzzle.name = [puzzleDic objectForKey:@"name"];
		puzzle.creatorID = [puzzleDic objectForKey:@"creator"];
		puzzle.dislikes = [[puzzleDic objectForKey:@"dislikes"] intValue];
		puzzle.likes = [[puzzleDic objectForKey:@"likes"] intValue];
		puzzle.rating = [[puzzleDic objectForKey:@"rating"] doubleValue] + .5;
		puzzle.taken = [[puzzleDic objectForKey:@"taken"] intValue];
		puzzle.timeCreated = [puzzleDic objectForKey:@"timestamp"];
		
		[puzzles addObject:puzzle];
	}
    
    self.onCompletion(self.response, puzzles); 
}

-(void) dealloc{
    [p_userID release]; 
	p_userID = nil;
	
    [super dealloc];
}

@end
