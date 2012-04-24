//
//  GetPuzzleOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPuzzleOperation.h"
#import "PuzzleAPIURLFactory.h"

@interface GetPuzzleOperation() {
    NSString* puzzle_ID;
}
@end

@implementation GetPuzzleOperation

-(id)initWithPuzzleID:(NSString*)puzzleID delegate:(id<PuzzleOperationDelegate>)delegate{
    self = [super init];
    if(self){
        puzzle_ID = puzzleID;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"GET"];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetPuzzle:puzzle_ID];
}


@end
