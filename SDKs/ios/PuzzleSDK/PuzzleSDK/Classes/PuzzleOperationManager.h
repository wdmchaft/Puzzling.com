//
//  PuzzleOperationManager.h
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleSDK.h"

@interface PuzzleOperationManager : NSObject

- (void)getPuzzleForID:(PuzzleID *)puzzleID;

@end
