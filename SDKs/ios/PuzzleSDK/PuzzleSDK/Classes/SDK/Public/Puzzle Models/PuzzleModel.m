//
//  PuzzlePuzzle.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleModel.h"


@interface PuzzleModel() {
    NSString* p_type; 
    NSDictionary* p_setupData;
    NSDictionary* p_solutionData;
    NSString* p_puzzleType;
    NSString* p_puzzleID;
}
@end

@implementation PuzzleModel

@synthesize type = p_type; 
@synthesize setupData = p_setupData;
@synthesize solutionData = p_solutionData;
@synthesize puzzleType = p_puzzleType;
@synthesize puzzleID = p_puzzleID;


- (void)uploadPuzzleOnCompletion:(PuzzleOnCompletionBlock)onCompletion {
	[[PuzzleSDK sharedInstance] createPuzzleWithType:self.puzzleType setupData:self.setupData solutionData:self.solutionData onCompletionBlock:onCompletion];
}

@end
