//
//  PuzzleOperation.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"
#import "PuzzleUser.h"
#import "JSONKit.h"


@interface PuzzleOperation() <NSURLConnectionDelegate> {
    NSURLConnection* puzzle_connection;
	PuzzleOnCompletionBlock puzzle_onCompletion;
	NSMutableData *puzzle_data;
}
@property (nonatomic, readwrite, retain) NSURLConnection* connection;
@property (nonatomic, readwrite, copy) PuzzleOnCompletionBlock onCompletion;
@property (nonatomic, readwrite, retain) NSMutableData *data;

@end

@implementation PuzzleOperation

@synthesize connection = puzzle_connection, onCompletion = puzzle_onCompletion, data = puzzle_data;

- (id)initWithOnCompletionBlock:(PuzzleOnCompletionBlock)onCompletionBlock {
	self = [super init];
	if (self) {
		self.onCompletion = onCompletionBlock;
	}
	return self;
}

-(void) start {
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

#pragma mark - NSConnectionDelegate Methods

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (self.data == nil) {
		self.data = [[NSMutableData alloc] init];
    }
    [self.data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    [puzzle_connection release];
    puzzle_connection = nil;
	
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		self.onCompletion(0, [self.data objectFromJSONData]);
	});
	[puzzle_data release];
	puzzle_data = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error 
{ 
	// release the connection, and the data object
	[puzzle_connection release];
	puzzle_connection = nil;
	[puzzle_data release]; 
	puzzle_data = nil; 
	NSLog(@"Connection failed! Error - %@", 
		  [error localizedDescription]); 
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"%@",response);
}

@end
