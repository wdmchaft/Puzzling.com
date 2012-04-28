//
//  PuzzleUser.h
//  PuzzleSDK
//
//  Created by Peter Livesey on 4/23/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleUser : NSObject

typedef NSString PuzzleUserID;

@property (nonatomic, readonly, retain) NSString *username;
@property (nonatomic, readonly, retain) PuzzleUserID *userID;
@property (nonatomic, readonly, retain) NSString *authToken;

+ (PuzzleUser *)currentUser;

@end
