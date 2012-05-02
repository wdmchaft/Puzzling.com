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
#define ADDITIONAL_DATA @"additionalData"
#define PUZZLE_TYPE @"puzzleType"
#define AUTHTOKEN @"authtoken"



@interface CreatePuzzleOperation() {
    NSString* p_type; 
    NSString* p_authToken;
    NSDictionary* p_setupData;
    NSDictionary* p_solutionData;
    NSDictionary* p_additionalData;
    NSString* p_puzzleType;
}
@property (nonatomic, retain, readwrite)NSString* type; 
@property (nonatomic, retain, readwrite)NSString* authToken; 
@property (nonatomic, retain, readwrite)NSDictionary* setupData;
@property (nonatomic, retain, readwrite)NSDictionary* solutionData;
@property (nonatomic, retain, readwrite)NSDictionary* additionalData;
@property (nonatomic, retain, readwrite)NSString* puzzleType;


@end


@implementation CreatePuzzleOperation

@synthesize type = p_type;
@synthesize authToken = p_authToken;
@synthesize setupData = p_setupData;
@synthesize solutionData = p_solutionData;
@synthesize additionalData = p_additionalData;
@synthesize puzzleType = p_puzzleType;

-(id)initWithType:(NSString*)type setupData:(NSDictionary*)setupData solutionData:(NSDictionary*)solutionData additionalData:(NSDictionary*)additionalData puzzleType:(NSString*)puzzleType authToken:(NSString*)authToken onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.type = type;
        self.authToken = authToken;
        self.setupData = setupData;
        self.solutionData = solutionData;
        self.additionalData = additionalData;
        self.puzzleType = puzzleType;
    }
    return self;
}


- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.type, TYPE, self.setupData, SETUP_DATA, self.solutionData, SOLUTION_DATA, self.additionalData, ADDITIONAL_DATA, self.puzzleType, PUZZLE_TYPE, self.authToken, AUTHTOKEN, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForCreatePuzzle];
}


-(void) dealloc{
    [p_type release]; 
    [p_authToken release];
    [p_setupData release];
    [ p_solutionData release];
    [p_additionalData release];
    [p_puzzleType release];
    [super dealloc];
}


@end
