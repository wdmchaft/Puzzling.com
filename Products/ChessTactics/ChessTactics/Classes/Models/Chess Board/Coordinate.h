//
//  Coordinate.h
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coordinate : NSObject

@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;

- (id)initWithX:(int)x Y:(int)y;

@end
