//
//  PuzzleOperation.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"
#import "PuzzleUser.h"


@interface PuzzleOperation() <NSURLConnectionDelegate> {
    NSURLConnection* puzzle_connection;
}
@property(nonatomic, readwrite, retain) NSURLConnection* connection; 

@end

@implementation PuzzleOperation

@synthesize connection = puzzle_connection;

-(void) start{
    self.connection = [[[NSURLConnection alloc] initWithRequest:[self httpRequest] delegate:self] autorelease];
    
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self url]];
    [request addValue:API_KEY forHTTPHeaderField:@"puzzle_api_key"];
    [request addValue:@"token" forHTTPHeaderField:@"puzzle_auth_token"];
    return request;
}

- (NSURL *)url {
    return nil;
}

- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isFinished{
    return false;
}

-(void) dealloc{
    [puzzle_connection release];
    puzzle_connection = nil;
    [super dealloc];
    
}

@end
