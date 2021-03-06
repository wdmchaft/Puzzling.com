//
//  PuzzlePuzzle.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleModel.h"


@interface PuzzleModel() {
    NSString* p_type; 
	NSString* p_name; 
    NSDictionary* p_setupData;
    NSDictionary* p_solutionData;
    NSString* p_puzzleType;
    NSString* p_puzzleID;
	PuzzleID* p_creatorID;
	int p_likes;
	int p_dislikes;
	int p_rating;
	int p_taken;
	NSString *p_timeCreated;
	BOOL p_removed;
	BOOL p_flagged;
}

@end

@implementation PuzzleModel

@synthesize name = p_name;
@synthesize type = p_type;
@synthesize setupData = p_setupData;
@synthesize solutionData = p_solutionData;
@synthesize puzzleType = p_puzzleType;
@synthesize puzzleID = p_puzzleID;
@synthesize creatorID = p_creatorID;
@synthesize likes = p_likes;
@synthesize dislikes = p_dislikes;
@synthesize rating = p_rating;
@synthesize taken = p_taken;
@synthesize timeCreated = p_timeCreated;
@synthesize removed = p_removed;
@synthesize flagged = p_flagged;


- (void)uploadPuzzleOnCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[[PuzzleSDK sharedInstance] createPuzzleWithType:self.puzzleType name:self.name setupData:self.setupData solutionData:self.solutionData isUpdate:nil onCompletionBlock:onCompletion];
}

- (void)dealloc {
	[p_name release];
	p_name = nil;
	[p_type release];
	p_type = nil;
	[p_timeCreated release];
	p_timeCreated = nil;
	[p_solutionData release];
	p_solutionData = nil;
	[p_setupData release];
	p_setupData = nil;
	[p_puzzleType release];
	p_puzzleType = nil;
	[p_puzzleID release];
	p_puzzleID = nil;
	[p_creatorID release];
	p_creatorID = nil;
	
	[super dealloc];
}

@end
