//
//  CreatePuzzleOperation.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"

@interface CreatePuzzleOperation : PuzzleOperation

-(id)initWithType:(NSString*)type setupData:(NSDictionary*)setupData solutionData:(NSDictionary*)solutionData additionalData:(NSDictionary*)additionalData puzzleType:(NSString*)puzzleType authToken:(NSString*)authToken onCompletionBlock:(PuzzleOnCompletionBlock)block;


@end
