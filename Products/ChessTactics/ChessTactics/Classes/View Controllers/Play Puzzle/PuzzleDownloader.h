//
//  PuzzleDownloader.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/5/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleModel.h"

@interface PuzzleDownloader : NSObject

+ (PuzzleDownloader *)sharedInstance;

- (void)downloadPuzzleWithCallback:(void(^)(PuzzleAPIResponse, PuzzleModel *))block;

@end
