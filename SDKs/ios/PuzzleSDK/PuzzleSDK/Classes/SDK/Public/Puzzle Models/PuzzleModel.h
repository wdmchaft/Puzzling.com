//
//  PuzzlePuzzle.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleModel : NSObject

@property (nonatomic, readonly, retain) NSString* type; 
@property (nonatomic, readonly, retain) NSDictionary* setupData;
@property (nonatomic, readonly, retain) NSDictionary* solutionData;
@property (nonatomic, readonly, retain) NSString* puzzleType;

@end
