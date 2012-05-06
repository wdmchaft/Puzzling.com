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
    NSString* p_username;
}
@property (nonatomic,retain,readwrite) NSString* username;
@end

@implementation GetPuzzlesMadeByUserOperation

@synthesize username = p_username;

-(id)initWithUsername:(NSString*)username onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.username = username;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"GET"];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetPuzzlesMadeByUser:self.username];
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
    [p_username release]; 
    [super dealloc];
}

@end
