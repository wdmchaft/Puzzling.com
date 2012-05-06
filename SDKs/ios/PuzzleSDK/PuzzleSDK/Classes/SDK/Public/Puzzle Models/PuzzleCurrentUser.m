//
//  PuzzleCurrentUser.m
//  PuzzleSDK
//
//  Created by Peter Livesey on 5/5/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleCurrentUser.h"
#import "UIApplication+Security.h"


#define USERNAME @"username"
#define USER_ID @"user_id"
#define USER_DATA @"user_data"
#define PUZZLE_CURRENT_USER @"puzzle_current_user"
#define PUZZLE_CURRENT_USER_AUTHTOKEN @"puzzle_current_user_authtoken"

@interface PuzzleCurrentUser() <NSCoding> {
	NSString *puzzle_authToken;
}

@property (nonatomic, readwrite, retain) NSString *authToken;

@end

@implementation PuzzleCurrentUser

@synthesize authToken = puzzle_authToken;

PuzzleCurrentUser * currentUser = nil;

+ (PuzzleCurrentUser *)currentUser {
	if (!currentUser) {
		NSData *currentUserData = [[NSUserDefaults standardUserDefaults] objectForKey:PUZZLE_CURRENT_USER];
		PuzzleCurrentUser *savedCurrentUser = [NSKeyedUnarchiver unarchiveObjectWithData:currentUserData];
		if (savedCurrentUser) {
			NSString *authToken = (NSString *)[UIApplication searchKeychainCopyMatching:PUZZLE_CURRENT_USER_AUTHTOKEN];
			if (authToken) {
				savedCurrentUser.authToken = authToken;
				currentUser = savedCurrentUser;
			}
		}
	}
	return currentUser;
}

- (void)save {
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:PUZZLE_CURRENT_USER];
	currentUser = self;
	
	[UIApplication deleteKeychainValue:PUZZLE_CURRENT_USER_AUTHTOKEN];
	[UIApplication createKeychainValue:self.authToken forIdentifier:PUZZLE_CURRENT_USER_AUTHTOKEN];
}

+ (void)logout {
	[currentUser release];
	currentUser = nil;
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:PUZZLE_CURRENT_USER];
	[UIApplication deleteKeychainValue:PUZZLE_CURRENT_USER_AUTHTOKEN];
}

#pragma mark - NSCoding Protocol

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		self.username = [aDecoder decodeObjectForKey:USERNAME];
		self.userID = [aDecoder decodeObjectForKey:USER_ID];
		self.userData = [aDecoder decodeObjectForKey:USER_DATA];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.username forKey:USERNAME];
	[aCoder encodeObject:self.userID forKey:USER_ID];
	[aCoder encodeObject:self.userData forKey:USER_DATA];
}

@end
