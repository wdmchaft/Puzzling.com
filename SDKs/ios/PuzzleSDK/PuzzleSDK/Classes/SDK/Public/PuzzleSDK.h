//
//  PuzzleSDK.h
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleErrorHandler.h"


typedef NSString PuzzleID;

typedef void(^PuzzleOnCompletionBlock)(PuzzleAPIResponse, id);

@interface PuzzleSDK : NSObject

+ (PuzzleSDK *)sharedInstance;
- (void)getPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion;
- (void)createPuzzleWithType:(NSString *)type setupData:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData onCompletionBlock:(PuzzleOnCompletionBlock)onCompletion;

@end
