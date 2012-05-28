//
//  PuzzleParsingHelpers.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/26/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PuzzleModel;

@interface PuzzleParsingHelpers : NSObject

+ (PuzzleModel *)parseDictionary:(NSDictionary *)data;

@end
