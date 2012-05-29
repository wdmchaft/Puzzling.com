//
//  LikeDislikeOperation.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/28/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "LikeDislikeOperation.h"
#import "JSONKit.h"
#import "PuzzleAPIURLFactory.h"


@interface LikeDislikeOperation() {
	PuzzleID *puzzle_puzzleID;
	BOOL puzzle_isLike;
}

@property (nonatomic, readwrite, retain) PuzzleID *puzzleID;
@property (nonatomic, readwrite, assign) BOOL isLike;

@end

@implementation LikeDislikeOperation

@synthesize puzzleID = puzzle_puzzleID, isLike = puzzle_isLike;

- (id)initWithPuzzleID:(PuzzleID *)puzzleID isLike:(BOOL)like onCompletion:(PuzzleOnCompletionBlock)block
{
	self = [super initWithOnCompletionBlock:block];
	if (self)
	{
		self.puzzleID = puzzleID;
		self.isLike = like;
	}
	return self;
}

- (NSMutableURLRequest *)httpRequest
{
	NSMutableURLRequest *request = [super httpRequest];
	request.HTTPMethod = @"POST";
	request.HTTPBody = [[NSDictionary dictionaryWithObject:self.puzzleID forKey:@"puzzle_id"] JSONData];
	
	return request;
}

- (NSURL *)url
{
	if (self.isLike)
	{
		return [PuzzleAPIURLFactory urlForLikePuzzle];
	}
	else
	{
		return [PuzzleAPIURLFactory urlForDislikePuzzle];
	}
}

- (void)dealloc
{
	[puzzle_puzzleID release];
	puzzle_puzzleID = nil;
	
	[super dealloc];
}

@end
