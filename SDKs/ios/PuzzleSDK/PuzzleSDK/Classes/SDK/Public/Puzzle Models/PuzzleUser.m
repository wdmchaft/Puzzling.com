//
//  PuzzleUser.m
//  PuzzleSDK
//
//  Created by Peter Livesey on 4/23/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "PuzzleUser.h"

@interface PuzzleUser() {
	NSString *puzzle_username;
	PuzzleUserID *puzzle_userID;
	NSDictionary *puzzle_userData;
	int puzzle_rating;
}

@end

@implementation PuzzleUser

@synthesize username = puzzle_username, userID = puzzle_userID, userData = puzzle_userData, rating = puzzle_rating;

- (void)dealloc
{
	[puzzle_userID release];
	puzzle_userID = nil;
	[puzzle_username release];
	puzzle_username = nil;
	[puzzle_userData release];
	puzzle_userData = nil;
	
	[super dealloc];
}

@end
