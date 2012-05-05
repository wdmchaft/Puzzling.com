//
//  PuzzleSDK.h
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleModel.h"
#import "PuzzleUser.h"

typedef enum {
    RequestSuccess
} PuzzleRequestStatus;

typedef NSString PuzzleID;

typedef void(^PuzzleOnCompletionBlock)(PuzzleRequestStatus, PuzzleModel*);
typedef void(^UserOnCompletionBlock)(PuzzleRequestStatus, PuzzleUser*);


@interface PuzzleSDK : NSObject

+ (PuzzleSDK *)sharedInstance;
- (void)getPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;

@end
