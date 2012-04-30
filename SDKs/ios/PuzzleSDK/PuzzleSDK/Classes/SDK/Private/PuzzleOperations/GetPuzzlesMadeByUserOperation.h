//
//  GetPuzzlesMadeByUserOperation.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"

@interface GetPuzzlesMadeByUserOperation : PuzzleOperation

-(id)initWithUsername:(NSString*)username onCompletionBlock:(PuzzleOnCompletionBlock)block;


@end
