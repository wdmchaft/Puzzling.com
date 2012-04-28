//
//  PuzzleErrorHandler.h
//  PuzzleSDK
//
//  Created by Peter Livesey on 4/27/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	PuzzleUnknownError = 0,
	PuzzleOperationSuccessful = 1
} PuzzleAPIResponse;

@interface PuzzleErrorHandler : NSObject

@end
