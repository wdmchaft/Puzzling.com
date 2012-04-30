//
//  CreateUserOperation.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"

@interface CreateUserOperation : PuzzleOperation

-(id)initWithUserName:(NSString*)userName password:(NSString*)password userData:(NSDictionary*)data onCompletionBlock:(PuzzleOnCompletionBlock)block;

@end
