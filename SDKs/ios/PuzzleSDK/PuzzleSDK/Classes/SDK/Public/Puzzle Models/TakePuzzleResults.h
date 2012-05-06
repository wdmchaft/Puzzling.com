//
//  TakePuzzleResults.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakePuzzleResults : NSObject

@property (nonatomic, readwrite, assign) int puzzleRatingChange;
@property (nonatomic, readwrite, assign) int userRatingChange;
@property (nonatomic, readwrite, assign) int newPuzzleRating;
@property (nonatomic, readwrite, assign) int newUserRating;

@end
