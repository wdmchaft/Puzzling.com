//
//  CreatePuzzleOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreatePuzzleOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"


#define USER_NAME @"username"
#define TYPE @"type"
#define SETUP_DATA @"setupData"
#define SOLUTION_DATA @"solutionData"
#define PUZZLE_TYPE @"puzzleType"

@interface CreatePuzzleOperation() {
    NSString* p_type; 
    NSDictionary* p_setupData;
    NSDictionary* p_solutionData;
}
@property (nonatomic, retain, readwrite)NSString* type; 
@property (nonatomic, retain, readwrite)NSDictionary* setupData;
@property (nonatomic, retain, readwrite)NSDictionary* solutionData;


@end


@implementation CreatePuzzleOperation

@synthesize type = p_type;
@synthesize setupData = p_setupData;
@synthesize solutionData = p_solutionData;

-(id)initWithType:(NSString*)type setupData:(NSDictionary*)setupData solutionData:(NSDictionary*)solutionData puzzleType:(NSString*)puzzleType onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.type = type;
        self.setupData = setupData;
        self.solutionData = solutionData;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.type, TYPE, self.setupData, SETUP_DATA, self.solutionData, SOLUTION_DATA, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForCreatePuzzle];
}

-(void) runCompletionBlock{
    PuzzleModel* puzzle = [[PuzzleModel alloc] init];
    
    NSDictionary* data = [self.data objectFromJSONData];
    puzzle.setupData = [data objectForKey:@"setupData"];
    puzzle.solutionData = [data objectForKey:@"solutionData"];
    puzzle.type = [data objectForKey:@"type"];
    puzzle.puzzleID = [data objectForKey:@"puzzleID"];
    
    self.onCompletion(self.response, puzzle); 
}

-(void) dealloc{
    [p_type release]; 
    [p_setupData release];
    [p_solutionData release];
    [super dealloc];
}


@end
