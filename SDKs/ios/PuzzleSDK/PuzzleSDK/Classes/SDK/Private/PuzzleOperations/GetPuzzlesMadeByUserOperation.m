//
//  GetPuzzlesMadeByUserOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPuzzlesMadeByUserOperation.h"
#import "PuzzleAPIURLFactory.h"


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

@end
