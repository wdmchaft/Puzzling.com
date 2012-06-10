//
//  PuzzleComment.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/20/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleSDK.h"


@interface PuzzleComment : NSObject

@property (nonatomic, readwrite, retain) NSString *message;
@property (nonatomic, readwrite, retain) NSString *poster;
@property (nonatomic, readwrite, retain) PuzzleID *posterID;

@end
