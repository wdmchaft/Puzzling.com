//
//  TDLabel.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 5/28/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDLabel.h"

@implementation TDLabel

- (id)init
{
    if (self = [super init]){
        UIFont * font = [UIFont fontWithName:@"Eraser" size:self.font.pointSize];
        if(font == nil) font = [UIFont fontWithName:@"Helvetica" size:self.font.pointSize];
        [self setFont: font];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder: decoder]){
        UIFont * font = [UIFont fontWithName:@"Eraser" size:self.font.pointSize];
        if(font == nil) font = [UIFont fontWithName:@"Helvetica" size:self.font.pointSize];
        [self setFont: font];
    }
    return self;
}

@end
