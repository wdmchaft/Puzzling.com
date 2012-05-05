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
#import "PuzzleAPIKey.h"
#import "PuzzleAPIURLFactory.h"


@interface PuzzleOperation() {
    NSURLConnection* puzzle_connection;
	PuzzleOnCompletionBlock puzzle_onCompletion;
	NSMutableData *puzzle_data;
	BOOL puzzle_isFinished;
	BOOL puzzle_isExecuting;
	PuzzleAPIResponse puzzle_response;
}

@property (nonatomic, readwrite, retain) NSURLConnection* connection;
@property (nonatomic, readwrite, copy) PuzzleOnCompletionBlock onCompletion;
@property (nonatomic, readwrite, retain) NSMutableData *data;
@property (nonatomic, readwrite, assign) BOOL isFinished;
@property (nonatomic, readwrite, assign) BOOL isExecuting;
@property (nonatomic, readwrite, assign) PuzzleAPIResponse response;

- (void)closeConnectionAndFinish;

@end

@implementation PuzzleOperation

@synthesize connection = puzzle_connection, onCompletion = puzzle_onCompletion, data = puzzle_data, isFinished = puzzle_isFinished, isExecuting = puzzle_isExecuting, response = puzzle_response;

- (id)initWithOnCompletionBlock:(PuzzleOnCompletionBlock)onCompletionBlock {
	self = [super init];
	if (self) {
		self.onCompletion = onCompletionBlock;
		self.isFinished = NO;
		self.isExecuting = NO;
	}
	return self;
}

- (void)start {
	if (![self isCancelled]) {
		[self willChangeValueForKey:@"isExecuting"];
		self.isExecuting = YES;
		[self didChangeValueForKey:@"isExecuting"];
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSURLRequest *request = [self httpRequest];
		self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
		NSLog(@"HTTP REQUEST:\n\nURL: %@\nMethod: %@\nBody: %@", request.URL, request.HTTPMethod, [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] autorelease]);
		[pool drain];
		CFRunLoopRun();
	} else {
		[self closeConnectionAndFinish];
	}
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self url]];
    [request addValue:API_KEY forHTTPHeaderField:@"puzzle_api_key"];
    [request addValue:@"petertest" forHTTPHeaderField:@"puzzle_auth_token"];
	[request addValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    return request;
}

- (NSURL *)url {
    return nil;
}

- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isExecuting {
	return puzzle_isExecuting;
}

- (BOOL)isFinished {
	return puzzle_isFinished;
}

-(void) dealloc{
    [puzzle_connection release];
    puzzle_connection = nil;
	[puzzle_data release];
	puzzle_data = nil;

    [super dealloc];
}

#pragma mark - Private Helper Methods

- (void)closeConnectionAndFinish {
	[self willChangeValueForKey:@"isExecuting"];
	self.isExecuting = NO;
	[self didChangeValueForKey:@"isExecuting"];
	[self willChangeValueForKey:@"isFinished"];
	self.isFinished = YES;
	[self didChangeValueForKey:@"isFinished"];
	
	[puzzle_connection release];
    puzzle_connection = nil;
	
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		self.onCompletion(self.response, [self.data objectFromJSONData]); //FIXME: This should be passing back an object, not an NSDictionary
	});
	
	CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark - NSConnectionDelegate Methods

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (self.data == nil) {
		self.data = [[[NSMutableData alloc] init] autorelease];
    }
    [self.data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	self.response = PuzzleOperationSuccessful;
	[self closeConnectionAndFinish];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error 
{
	[self closeConnectionAndFinish];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
}

@end
