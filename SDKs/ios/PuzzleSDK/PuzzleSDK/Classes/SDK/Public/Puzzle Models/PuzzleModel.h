//
//  PuzzlePuzzle.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleSDK.h"

@interface PuzzleModel : NSObject

@property (nonatomic, readwrite, retain) NSString* name; 
@property (nonatomic, readwrite, retain) NSString* type; 
@property (nonatomic, readwrite, retain) NSDictionary* setupData;
@property (nonatomic, readwrite, retain) NSDictionary* solutionData;
@property (nonatomic, readwrite, retain) NSString* puzzleType;
@property (nonatomic, readwrite, retain) NSString* puzzleID;
@property (nonatomic, readwrite, retain) PuzzleID* creatorID;
@property (nonatomic, readwrite, assign) int likes;
@property (nonatomic, readwrite, assign) int dislikes;
@property (nonatomic, readwrite, assign) int rating;
@property (nonatomic, readwrite, assign) int taken;
@property (nonatomic, readwrite, retain) NSString *timeCreated;


- (void)uploadPuzzleOnCompletion:(PuzzleOnCompletionBlock)onCompletion;

@end
