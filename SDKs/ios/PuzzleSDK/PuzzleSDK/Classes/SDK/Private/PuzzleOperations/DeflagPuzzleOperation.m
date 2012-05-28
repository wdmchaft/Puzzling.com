//
//  DeflagPuzzleOperation.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/26/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "DeflagPuzzleOperation.h"
#import "PuzzleAPIURLFactory.h"


@interface DeflagPuzzleOperation() {
	PuzzleID *puzzle_puzzleID;
}

@property (nonatomic, readwrite, retain) PuzzleID *puzzleID;

@end

@implementation DeflagPuzzleOperation

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
	request.HTTPMethod = @"POST";
	
	return request;
}

- (NSURL *)url
{
	return [PuzzleAPIURLFactory urlForDeflagPuzzle:self.puzzleID];
}

- (void)dealloc
{
	[puzzle_puzzleID release];
	puzzle_puzzleID = nil;
	
	[super dealloc];
}

@end
