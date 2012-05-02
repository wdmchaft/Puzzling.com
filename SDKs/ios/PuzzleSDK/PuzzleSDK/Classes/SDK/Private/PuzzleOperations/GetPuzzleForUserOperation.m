//
//  GetPuzzleForUser.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPuzzleForUserOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"



@interface GetPuzzleForUserOperation() {
}
@end

@implementation GetPuzzleForUserOperation


- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"GET"];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetPuzzleForUser];
}

-(void) dealloc{
    [super dealloc];
}

@end
