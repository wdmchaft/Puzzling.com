//
//  ChessPiece.h
//  Frisky Chess
//
//  Created by Peter Livesey on 1/11/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovementVectors.h"


typedef enum {
	kWhite = 0,
    kBlack = 1
} Color;

@interface ChessPiece : NSObject

@property (nonatomic, assign) Color color;
@property (nonatomic, retain) UIImageView * view;
@property (nonatomic, readonly) NSString * imageName;
@property (nonatomic, readonly) MovementVectors * movementVectors;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@property (nonatomic, assign) BOOL moved;
@property (nonatomic, retain) NSString * tag;

- (id)initWithColor:(Color)color tag:(int)tagInt;

@end
