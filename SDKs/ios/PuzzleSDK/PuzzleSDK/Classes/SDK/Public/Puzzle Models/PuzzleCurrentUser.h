//
//  PuzzleCurrentUser.h
//  PuzzleSDK
//
//  Created by Peter Livesey on 5/5/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleUser.h"

@interface PuzzleCurrentUser : PuzzleUser

@property (nonatomic, readonly, retain) NSString *authToken;

+ (PuzzleUser *)currentUser;
+ (void)logout;
- (void)save;

@end
