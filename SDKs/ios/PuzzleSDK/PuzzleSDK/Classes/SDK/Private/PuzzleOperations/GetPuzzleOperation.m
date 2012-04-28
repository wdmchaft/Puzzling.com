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
@property (nonatomic,retain,readwrite) NSString* puzzleID;
@end

@implementation GetPuzzleOperation

@synthesize puzzleID = puzzle_ID;

-(id)initWithPuzzleID:(NSString*)puzzleID onCompletionBlock:(PuzzleOnCompletionBlock)block delegate:(id<NSURLConnectionDelegate>)delegate{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.puzzleID = puzzleID;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"GET"];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetPuzzle:self.puzzleID];
}


@end
