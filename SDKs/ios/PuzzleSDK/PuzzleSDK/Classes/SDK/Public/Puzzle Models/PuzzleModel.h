//
//  PuzzlePuzzle.h
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleModel : NSObject

@property (nonatomic, readwrite, retain) NSString* type; 
@property (nonatomic, readwrite, retain) NSDictionary* setupData;
@property (nonatomic, readwrite, retain) NSDictionary* solutionData;
@property (nonatomic, readwrite, retain) NSString* puzzleType;
@property (nonatomic, readwrite, retain) NSString* puzzleID;


@end
