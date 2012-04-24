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


@interface PuzzleOperation() {
    NSURLConnection* puzzle_connection;
	PuzzleOnCompletionBlock puzzle_onCompletion;
	NSMutableData *puzzle_data;
	BOOL puzzle_isFinished;
	id<NSURLConnectionDelegate> puzzle_delegate;
}
@property (nonatomic, readwrite, retain) NSURLConnection* connection;
@property (nonatomic, readwrite, copy) PuzzleOnCompletionBlock onCompletion;
@property (nonatomic, readwrite, retain) NSMutableData *data;
@property (nonatomic, readwrite, assign) BOOL isFinished;

@end

@implementation PuzzleOperation

@synthesize connection = puzzle_connection, onCompletion = puzzle_onCompletion, data = puzzle_data, isFinished = puzzle_isFinished, delegate = puzzle_delegate;

- (id)initWithOnCompletionBlock:(PuzzleOnCompletionBlock)onCompletionBlock {
	self = [super init];
	if (self) {
		self.onCompletion = onCompletionBlock;
		self.isFinished = NO;
	}
	return self;
}

- (void)start {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	self.connection = [NSURLConnection connectionWithRequest:[self httpRequest] delegate:self.delegate];
	[pool drain];
	CFRunLoopRun();
}

- (void)main {
	[self.connection start];
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self url]];
    [request addValue:API_KEY forHTTPHeaderField:@"puzzle_api_key"];
    [request addValue:@"petertest" forHTTPHeaderField:@"puzzle_auth_token"];
	NSLog(@"HTTP REQUEST:\n\nURL: %@\nMethod: %@\nBody: %@", request.URL, request.HTTPMethod, request.HTTPBody);
    return request;
}

- (NSURL *)url {
    return nil;
}

- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isExecuting {
	return YES;
}

- (BOOL)isFinished {
	return NO;
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
	NSLog(@"%@", [[[NSString alloc] initWithData:incrementalData encoding:NSUTF8StringEncoding] autorelease]);
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    [puzzle_connection release];
    puzzle_connection = nil;
	
	self.isFinished = YES;
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		self.onCompletion(0, [self.data objectFromJSONData]);
	});
	[puzzle_data release];
	puzzle_data = nil;
	NSLog(@"Connection finished");
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error 
{ 
	// release the connection, and the data object
//	[puzzle_connection release];
//	puzzle_connection = nil;
//	[puzzle_data release]; 
//	puzzle_data = nil; 
	CFRunLoopStop(CFRunLoopGetCurrent());
	NSLog(@"Connection failed! Error - %@", 
		  [error localizedDescription]); 
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Connection received response.");
}

@end
