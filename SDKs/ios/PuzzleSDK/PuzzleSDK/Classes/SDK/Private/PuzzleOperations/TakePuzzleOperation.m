//
//  TakePuzzleOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TakePuzzleOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"
#import "TakePuzzleResults.h"

#define PUZZLE_ID @"puzzleType"
#define SCORE @"score"

@interface TakePuzzleOperation() {
    PuzzleID* p_puzzleID;
    float p_score;
	BOOL p_rated;
}
@property (nonatomic,retain,readwrite) PuzzleID* puzzleID;
@property (nonatomic,assign,readwrite) float score;
@property (nonatomic, readwrite, assign) BOOL rated;

@end

@implementation TakePuzzleOperation

@synthesize puzzleID = p_puzzleID;
@synthesize score = p_score;
@synthesize rated = p_rated;

-(id)initWithPuzzleID:(PuzzleID*)puzzleID score:(float)score rated:(BOOL)rated onCompletionBlock:(PuzzleOnCompletionBlock)block {
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.puzzleID = puzzleID;
        self.score = score;
		self.rated = rated;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.score], SCORE, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForTakenPuzzle:self.puzzleID rated:self.rated];
}

- (void)runCompletionBlock{
    TakePuzzleResults* results = [[[TakePuzzleResults alloc] init] autorelease];
    
    NSDictionary* data = [self.data objectFromJSONData];
    results.userRatingChange = [[data objectForKey:@"playerRatingChange"] doubleValue] + .5;
    results.newUserRating = [[data objectForKey:@"newPlayerRating"] doubleValue] + .5;
    results.newPuzzleRating = [[data objectForKey:@"newPuzzleRating"] doubleValue] + .5;
    results.puzzleRatingChange = [[data objectForKey:@"puzzleRatingChange"] doubleValue] + .5;

    self.onCompletion(self.response, results); 
}

-(void) dealloc{
    [p_puzzleID release];
	p_puzzleID = nil;
	
    [super dealloc];
}

@end
