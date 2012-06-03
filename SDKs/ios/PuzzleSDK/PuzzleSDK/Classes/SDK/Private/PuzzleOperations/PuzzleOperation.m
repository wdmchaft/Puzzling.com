//
//  PuzzleOperation.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"
#import "PuzzleAPIKey.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"
#import "PuzzleErrorHandler.h"
#import "PuzzleCurrentUser.h"


#define ERROR_CODE @"error"

@interface PuzzleOperation() {
    NSURLConnection* puzzle_connection;
	PuzzleOnCompletionBlock puzzle_onCompletion;
    PuzzleAPIResponse puzzle_response;
	NSMutableData *puzzle_data;
	BOOL puzzle_isFinished;
	BOOL puzzle_isExecuting;
	int puzzle_statusCode;
}

@property (nonatomic, readwrite, retain) NSURLConnection* connection;
@property (nonatomic, readwrite, assign) BOOL isFinished;
@property (nonatomic, readwrite, assign) BOOL isExecuting;
@property (nonatomic, readwrite, assign) PuzzleAPIResponse response;
@property (nonatomic, readwrite, assign) int statusCode;

- (void)closeConnectionAndFinish;
- (void)handleError;

@end

@implementation PuzzleOperation

@synthesize connection = puzzle_connection, onCompletion = puzzle_onCompletion, data = puzzle_data, isFinished = puzzle_isFinished, isExecuting = puzzle_isExecuting, response = puzzle_response, statusCode = puzzle_statusCode;

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
    [request addValue:[NSString stringWithFormat:@"%@ %@", API_KEY, [PuzzleCurrentUser currentUser].authToken] forHTTPHeaderField:@"Authorization"];
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

- (void)dealloc{
    [puzzle_connection release];
    puzzle_connection = nil;
	[puzzle_data release];
	puzzle_data = nil;
	
	if (self.onCompletion) {
		[self.onCompletion release];
		self.onCompletion = nil;
	}

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
	
	NSLog(@"%@", [[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding] autorelease]);
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		if (self.response == PuzzleOperationSuccessful)
		{
			[self runCompletionBlock];
		}
		else
		{
			self.onCompletion(self.response, [self.data objectFromJSONData]); //error so don't run operation
		}
	});
	
	CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)runCompletionBlock{
    self.onCompletion(self.response, [self.data objectFromJSONData]);  //Override with actual objects being passed to completion block
}

- (void)handleError 
{
	NSDictionary *errorDictionary = [self.data objectFromJSONData];
	NSString *error = [errorDictionary objectForKey:ERROR_CODE];
	self.response = [PuzzleErrorHandler errorForString:error];
}

#pragma mark - NSConnectionDelegate Methods

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (self.data == nil) {
		self.data = [[[NSMutableData alloc] init] autorelease];
    }
    [self.data appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	self.statusCode = [httpResponse statusCode];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	if (self.statusCode >= 200 && self.statusCode <= 204)
	{
		self.response = PuzzleOperationSuccessful;
	}
	else
	{
		[self handleError];
	}
	[self closeConnectionAndFinish];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error 
{
	if ([error code] == NSURLErrorBadURL) {
		self.response = PuzzleErrorMalformedOperation;
	} else if ([error code] == NSURLErrorNetworkConnectionLost || [error code] == NSURLErrorNotConnectedToInternet || [error code] == NSURLErrorInternationalRoamingOff) {
		self.response = PuzzleErrorInternetProblem;
	} else if ([error code] == NSURLErrorCannotFindHost || [error code] == NSURLErrorCannotConnectToHost || [error code] == NSURLErrorTimedOut) {
		self.response = PuzzleErrorConnectionProblem;
	} 
	[self closeConnectionAndFinish];
}

#pragma mark - NSConnectionDelegate Security Methods

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
   
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if ([challenge.protectionSpace.host isEqualToString:@"ec2-184-169-151-249.us-west-1.compute.amazonaws.com"]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
