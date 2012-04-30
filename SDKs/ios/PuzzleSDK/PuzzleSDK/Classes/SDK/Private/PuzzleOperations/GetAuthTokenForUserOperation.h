//
//  GetAuthTokenForUserOperation.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperation.h"

@interface GetAuthTokenForUserOperation : PuzzleOperation

-(id)initWithUserName:(NSString*)userName password:(NSString*)password onCompletionBlock:(PuzzleOnCompletionBlock)block;

@end
