//
//  CreatePuzzleOperation.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"

@interface CreatePuzzleOperation : PuzzleOperation

-(id)initWithType:(NSString*)type name:(NSString*)name setupData:(NSDictionary*)setupData solutionData:(NSDictionary*)solutionData puzzleType:(NSString*)puzzleType isUpdate:(PuzzleID *)puzzleID onCompletionBlock:(PuzzleOnCompletionBlock)block;


@end
