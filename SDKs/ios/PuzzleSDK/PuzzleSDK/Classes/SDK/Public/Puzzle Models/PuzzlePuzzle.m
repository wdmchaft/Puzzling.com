//
//  PuzzlePuzzle.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzlePuzzle.h"

@interface PuzzlePuzzle() {
    NSString* p_type; 
    NSDictionary* p_setupData;
    NSDictionary* p_solutionData;
    NSString* p_puzzleType;
    
}
@end

@implementation PuzzlePuzzle

@synthesize type = p_type; 
@synthesize setupData = p_setupData;
@synthesize solutionData = p_solutionData;
@synthesize puzzleType = p_puzzleType;

@end
