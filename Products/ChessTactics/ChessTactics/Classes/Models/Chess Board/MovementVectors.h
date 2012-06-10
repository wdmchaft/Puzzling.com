//
//  MovementVectors.h
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovementVectors : NSObject

@property (nonatomic, retain) NSMutableArray * vectors;
@property (nonatomic, assign) BOOL infiniteMovement;

@end
