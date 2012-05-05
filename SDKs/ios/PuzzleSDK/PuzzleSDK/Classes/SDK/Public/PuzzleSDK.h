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
#import "PuzzleErrorHandler.h"


typedef NSString PuzzleID;

typedef void(^UserOnCompletionBlock)(PuzzleRequestStatus, PuzzleUser*);
typedef void(^PuzzleOnCompletionBlock)(PuzzleAPIResponse, id);

@interface PuzzleSDK : NSObject

+ (PuzzleSDK *)sharedInstance;
- (void)getPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;
- (void)getPuzzleForCurrentUserOnCompletion:(PuzzleOnCompletionBlock)onCompletion;
- (void)createPuzzleWithType:(NSString *)type setupData:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData onCompletionBlock:(PuzzleOnCompletionBlock)onCompletion;

@end
