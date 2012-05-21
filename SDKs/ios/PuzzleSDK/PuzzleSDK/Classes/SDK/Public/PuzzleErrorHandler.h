//
//  PuzzleErrorHandler.h
//  PuzzleSDK
//
//  Created by Peter Livesey on 4/27/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	PuzzleErrorUnknown = 0,
	PuzzleOperationSuccessful = 1,
	PuzzleErrorInvalidPassword,
	PuzzleErrorUsernameNotFound,
	PuzzleErrorUsernameAlreadyExists,
	PuzzleErrorCannotFindUser,
	PuzzleErrorInvalidAuthtoken,
	PuzzleErrorInternalServer,
	PuzzleErrorNoPuzzlesToSuggest,
	PuzzleErrorPuzzleDoesntExist,
	PuzzleErrorAPIKey
} PuzzleAPIResponse;

@interface PuzzleErrorHandler : NSObject

+ (PuzzleAPIResponse)errorForString:(NSString *)error;
+ (NSString *)messageForError:(PuzzleAPIResponse)error;
+ (void)presentErrorForResponse:(PuzzleAPIResponse)error;

@end
