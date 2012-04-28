//
//  PuzzleOperation.h
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleErrorHandler.h"
#import "PuzzleSDK.h"


@interface PuzzleOperation : NSOperation

@property (nonatomic, readonly, assign) PuzzleAPIResponse response;

- (id)initWithOnCompletionBlock:(PuzzleOnCompletionBlock)onCompletionBlock;
- (NSMutableURLRequest *)httpRequest;
- (NSURL *)url;

@end
