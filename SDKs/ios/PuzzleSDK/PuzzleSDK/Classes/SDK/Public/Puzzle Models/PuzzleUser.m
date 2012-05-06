//
//  PuzzleUser.m
//  PuzzleSDK
//
//  Created by Peter Livesey on 4/23/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleUser.h"

@interface PuzzleUser() {
	NSString *puzzle_username;
	PuzzleUserID *puzzle_userID;
	NSDictionary *puzzle_userData;
}

@end

@implementation PuzzleUser

@synthesize username = puzzle_username, userID = puzzle_userID, userData = puzzle_userData;

@end
