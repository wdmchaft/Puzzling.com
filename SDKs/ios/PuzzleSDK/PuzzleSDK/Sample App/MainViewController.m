//
//  MainViewController.m
//  PuzzleSDK
//
//  Created by Peter Livesey on 4/23/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "MainViewController.h"
#import "PuzzleSDK.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (IBAction)getPuzzle:(id)sender {
	[[PuzzleSDK sharedInstance] getPuzzle:@"4f9204c648a71e7312000003" onCompletion:^(PuzzleRequestStatus status, id data) {
		NSLog(@"Status: %d", status);
		NSLog(@"Data: %@", data);
	}];
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	NSURLConnection *connection = [[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]] delegate:self] retain];
//	[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//	[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//	[connection start];
//	[pool drain];
}

#pragma mark - NSConnectionDelegate Methods

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {

}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
   
}
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error 
{ 
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"%@",response);
}


@end
