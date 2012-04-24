//
//  PuzzleOperationManager.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperationManager.h"
#import "GetPuzzleOperation.h"


@interface PuzzleOperationManager() <NSURLConnectionDelegate> {
    NSOperationQueue *puzzle_queue;
}

@property (nonatomic, readwrite, retain) NSOperationQueue *queue;

@end

@implementation PuzzleOperationManager

@synthesize queue = puzzle_queue;

- (id)init {
    self = [super init];
    if (self) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
    }
    return self;
}

- (void)getPuzzleForID:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetPuzzleOperation * operation = [[GetPuzzleOperation alloc] initWithPuzzleID:puzzleID onCompletionBlock:onCompletion delegate:self];
	[self.queue addOperation:operation];
}


#pragma mark - NSConnectionDelegate Methods

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
//    if (self.data == nil) {
//		self.data = [[NSMutableData alloc] init];
//    }
//    [self.data appendData:incrementalData];
	NSLog(@"%@", [[[NSString alloc] initWithData:incrementalData encoding:NSUTF8StringEncoding] autorelease]);
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
//    [puzzle_connection release];
//    puzzle_connection = nil;
//	
//	self.isFinished = YES;
//	dispatch_async(dispatch_get_main_queue(), ^(void) {
//		self.onCompletion(0, [self.data objectFromJSONData]);
//	});
//	[puzzle_data release];
//	puzzle_data = nil;
	NSLog(@"Connection finished");
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error 
{ 
	// release the connection, and the data object
	//	[puzzle_connection release];
	//	puzzle_connection = nil;
	//	[puzzle_data release]; 
	//	puzzle_data = nil; 
//	CFRunLoopStop(CFRunLoopGetCurrent());
	NSLog(@"Connection failed! Error - %@", 
		  [error localizedDescription]); 
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"%@",response);
}

@end
