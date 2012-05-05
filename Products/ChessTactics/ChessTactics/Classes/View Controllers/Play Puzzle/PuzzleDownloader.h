//
//  PuzzleDownloader.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/5/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzlePuzzle.h"

@interface PuzzleDownloader : NSObject

+ (PuzzleDownloader *)sharedInstance;

- (void)downloadPuzzleWithCallback:(void(^)(PuzzlePuzzle *))block;

@end
