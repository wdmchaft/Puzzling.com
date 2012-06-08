//
//  PuzzleCurrentUser.h
//  PuzzleSDK
//
//  Created by Peter Livesey on 5/5/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "PuzzleUser.h"

@interface PuzzleCurrentUser : PuzzleUser

@property (nonatomic, readwrite, retain) NSString *authToken;
@property (nonatomic, readonly, assign) BOOL isLoggedIn;

+ (PuzzleCurrentUser *)currentUser;
+ (void)logout;
- (void)save;

@end
