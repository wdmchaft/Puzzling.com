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
#import "PuzzleModel.h"


#define USER_NAME @"username"
#define PUZZLE_NAME @"puzzleName"
#define TYPE @"type"
#define SETUP_DATA @"setupData"
#define SOLUTION_DATA @"solutionData"
#define PUZZLE_TYPE @"puzzleType"

@interface CreatePuzzleOperation() {
    NSString* p_type; 
    NSString* p_name; 
    NSDictionary* p_setupData;
    NSDictionary* p_solutionData;
}
@property (nonatomic, retain, readwrite) NSString* type;
@property (nonatomic, retain, readwrite) NSString* name;
@property (nonatomic, retain, readwrite) NSDictionary* setupData;
@property (nonatomic, retain, readwrite) NSDictionary* solutionData;


@end


@implementation CreatePuzzleOperation

@synthesize type = p_type, name = p_name;
@synthesize setupData = p_setupData;
@synthesize solutionData = p_solutionData;

- (id)initWithType:(NSString*)type name:(NSString*)name setupData:(NSDictionary*)setupData solutionData:(NSDictionary*)solutionData puzzleType:(NSString*)puzzleType onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.type = type;
        self.setupData = setupData;
        self.solutionData = solutionData;
		self.name = name;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
	NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:4];
	if (self.type) {
		[data setValue:self.type forKey:TYPE];
	}
	if (self.name) {
		[data setValue:self.name forKey:PUZZLE_NAME];
	}
	if (self.setupData) {
		[data setValue:self.setupData forKey:SETUP_DATA];
	}
	if (self.solutionData) {
		[data setValue:self.solutionData forKey:SOLUTION_DATA];
	}
    NSData* jsonData = [data JSONData];
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
	p_type = nil;
	[p_name release];
	p_name = nil;
    [p_setupData release];
	p_setupData = nil;
    [p_solutionData release];
	p_solutionData = nil;
	
    [super dealloc];
}


@end
