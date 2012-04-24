//
//  GetPuzzleOperation.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"

@interface GetPuzzleOperation : PuzzleOperation

-(id)initWithPuzzleID:(NSString*)puzzleID onCompletionBlock:(PuzzleOnCompletionBlock)block delegate:(id<NSURLConnectionDelegate>)delegate;

@end
