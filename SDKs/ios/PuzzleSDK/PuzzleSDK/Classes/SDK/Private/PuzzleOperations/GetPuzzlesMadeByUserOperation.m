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
#import "PuzzleParsingHelpers.h"

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
		PuzzleModel* puzzle = [PuzzleParsingHelpers parseDictionary:puzzleDic];
		
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
