//
//  CreateAppOperation.h
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/4/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "PuzzleOperation.h"

@interface CreateAppOperation : PuzzleOperation

-(id)initWithName:(NSString*)userName onCompletionBlock:(PuzzleOnCompletionBlock)block;


@end
