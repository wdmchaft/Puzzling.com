//
//  GetCommentsOperation.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/23/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "GetCommentsOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"
#import "PuzzleComment.h"


@interface GetCommentsOperation() {
	PuzzleID *puzzle_puzzleID;
}

@property (nonatomic, readwrite, retain) PuzzleID *puzzleID;

@end

@implementation GetCommentsOperation

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

- (NSURL *)url
{
	return [PuzzleAPIURLFactory urlForComment:self.puzzleID];
}

- (void)runCompletionBlock
{
	NSArray *commentsData = [self.data objectFromJSONData];
	NSMutableArray *comments = [NSMutableArray array];
	
	for (NSDictionary *data in commentsData)
	{
		PuzzleComment *comment = [[[PuzzleComment alloc] init] autorelease];
		comment.poster = [data objectForKey:@"username"];
		comment.posterID = [data objectForKey:@"user"];
		comment.message = [data objectForKey:@"value"];
		[comments addObject:comment]; 
	}
	
	self.onCompletion(self.response, comments);
}

- (void)dealloc
{
	[puzzle_puzzleID release];
	puzzle_puzzleID = nil;
	
	[super dealloc];
}

@end
