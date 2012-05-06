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
}
@property (nonatomic,retain,readwrite) PuzzleID* puzzleID;
@property (nonatomic,assign,readwrite) float score;

@end

@implementation TakePuzzleOperation

@synthesize puzzleID = p_puzzleID;
@synthesize score = p_score;

-(id)initWithPuzzleID:(PuzzleID*)puzzleID score:(float)score onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.puzzleID = puzzleID;
        self.score = score;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys: self.puzzleID, PUZZLE_ID, self.score,SCORE, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForTakenPuzzle:self.puzzleID];
}

-(void) runCompletionBlock{
    TakePuzzleResults* results = [[TakePuzzleResults alloc] init];
    
    NSDictionary* data = [self.data objectFromJSONData];
    results.userRatingChange = [[data objectForKey:@"userRatingChange"]intValue];
    results.newUserRating = [[data objectForKey:@"newUserRating"]intValue];
    results.newPuzzleRating = [[data objectForKey:@"newPuzzleRating"]intValue];
    results.puzzleRatingChange = [[data objectForKey:@"puzzleRatingChange"]intValue];

    self.onCompletion(self.response, results); 
}

-(void) dealloc{
    [p_puzzleID release];
    [super dealloc];
}

@end
