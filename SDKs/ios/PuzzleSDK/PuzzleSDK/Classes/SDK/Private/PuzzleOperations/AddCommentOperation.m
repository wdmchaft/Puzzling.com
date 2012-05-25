//
//  AddCommentOperation.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/23/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "AddCommentOperation.h"
#import "JSONKit.h"
#import "PuzzleAPIURLFactory.h"


@interface AddCommentOperation() {
	PuzzleID *puzzle_puzzleID;
	NSString *puzzle_comment;
}

@property (nonatomic, readwrite, retain) PuzzleID *puzzleID;
@property (nonatomic, readwrite, retain) NSString *comment;

@end

@implementation AddCommentOperation

@synthesize puzzleID = puzzle_puzzleID, comment = puzzle_comment;

- (id)initWithPuzzleID:(PuzzleID *)puzzleID comment:(NSString *)comment onCompletion:(PuzzleOnCompletionBlock)block
{
	self = [super initWithOnCompletionBlock:block];
	if (self)
	{
		self.puzzleID = puzzleID;
		self.comment = comment;
	}
	return self;
}

- (NSMutableURLRequest *)httpRequest
{
	NSMutableURLRequest *request = [super httpRequest];
	request.HTTPMethod = @"POST";
	request.HTTPBody = [[NSDictionary dictionaryWithObject:self.comment forKey:@"comment"] JSONData];
	
	return request;
}

- (NSURL *)url
{
	return [PuzzleAPIURLFactory urlForComment:self.puzzleID];
}

- (void)runCompletionBlock
{
	self.onCompletion(self.response, nil);
}

- (void)dealloc
{
	[puzzle_comment release];
	puzzle_comment = nil;
	[puzzle_puzzleID release];
	puzzle_puzzleID = nil;
	
	[super dealloc];
}

@end
