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

#define PUZZLE_ID @"puzzleType"
#define AUTHTOKEN @"authtoken"
#define SCORE @"score"

@interface TakePuzzleOperation() {
    NSString* p_authToken;
    PuzzleID* p_puzzleID;
    float p_score;
}
@property (nonatomic,retain,readwrite) NSString* authToken;
@property (nonatomic,retain,readwrite) PuzzleID* puzzleID;
@property (nonatomic,assign,readwrite) float score;

@end

@implementation TakePuzzleOperation

@synthesize authToken = p_authToken;
@synthesize puzzleID = p_puzzleID;
@synthesize score = p_score;

-(id)initWithAuthtoken:(NSString*)authtoken puzzleID:(PuzzleID*)puzzleID score:(float)score onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.authToken = authtoken;
        self.puzzleID = puzzleID;
        self.score = score;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.authToken, AUTHTOKEN, self.puzzleID, PUZZLE_ID, self.score,SCORE, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForTakenPuzzle:self.puzzleID];
}

-(void) dealloc{
    [p_authToken release];
    [p_puzzleID release];
    [super dealloc];
}

@end
