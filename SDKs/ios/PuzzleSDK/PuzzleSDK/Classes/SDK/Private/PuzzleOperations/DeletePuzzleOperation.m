//
//  DeletePuzzleOperation.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/26/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "DeletePuzzleOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"


@interface DeletePuzzleOperation() {
	PuzzleID *puzzle_puzzleID;
}

@property (nonatomic, readwrite, retain) PuzzleID *puzzleID;

@end

@implementation DeletePuzzleOperation

@synthesize puzzleID = puzzle_puzzleID;

- (id)initWithPuzzleID:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)block
{
	self = [super initWithOnCompletionBlock:block];
	if (self)
	{
		self.puzzleID = puzzleID;
	}
	return self;
}

- (NSMutableURLRequest *)httpRequest
{
	NSMutableURLRequest *request = [super httpRequest];
	request.HTTPMethod = @"DELETE";
	request.HTTPBody = [[NSDictionary dictionaryWithObject:self.puzzleID forKey:@"puzzle_id"] JSONData];
	
	return request;
}

- (NSURL *)url
{
	return [PuzzleAPIURLFactory urlForDeletePuzzle];
}

- (void)dealloc
{
	[puzzle_puzzleID release];
	puzzle_puzzleID = nil;
	
	[super dealloc];
}

@end
