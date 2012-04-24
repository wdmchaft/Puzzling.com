//
//  GetPuzzleOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPuzzleOperation.h"


@interface GetPuzzleOperation() {
    NSString* puzzle_ID;
}
@end

@implementation GetPuzzleOperation

-(id)initWithPuzzleID:(NSString*)puzzleID onCompletionBlock:(PuzzleOnCompletionBlock)block delegate:(id<PuzzleOperationDelegate>)delegate{
    self = [super initWithOnCompletionBlock:block];
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
