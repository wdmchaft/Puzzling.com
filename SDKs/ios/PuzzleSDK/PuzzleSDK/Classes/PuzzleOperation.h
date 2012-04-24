//
//  PuzzleOperation.h
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleAPIKey.h"
#import "PuzzleAPIURLFactory.h"


@interface PuzzleOperation : NSOperation

- (NSMutableURLRequest *)httpRequest;
- (NSURL *)url;

@end

@protocol PuzzleOperationDelegate <NSObject>

@end
