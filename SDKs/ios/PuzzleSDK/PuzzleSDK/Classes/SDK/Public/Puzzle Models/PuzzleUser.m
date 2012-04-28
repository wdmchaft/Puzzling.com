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
	NSString *puzzle_authToken;
}

@property (nonatomic, readwrite, retain) NSString *username;
@property (nonatomic, readwrite, retain) PuzzleUserID *userID;
@property (nonatomic, readwrite, retain) NSString *authToken;


@end

@implementation PuzzleUser

@synthesize username = puzzle_username, userID = puzzle_userID, authToken = puzzle_authToken;

PuzzleUser * currentUser = nil;

+ (PuzzleUser *)currentUser {
	if (!currentUser) {
		currentUser = [[PuzzleUser alloc] init];
		currentUser.authToken = @"petertest";
	}
	return currentUser;
}

@end
