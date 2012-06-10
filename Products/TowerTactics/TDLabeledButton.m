//
//  TDLabeledButton.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 5/28/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDLabeledButton.h"

@interface TDLabeledButton()

-(void) setup;

@end

@implementation TDLabeledButton

-(void) setup{
    UIFont * font = [UIFont fontWithName:@"Eraser" size:self.titleLabel.font.pointSize];
    if(font != nil) 
        self.titleLabel.font = font;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];  
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];  
}

- (id)init
{
    if (self = [super init]){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder: decoder]){
        [self setup];
    }
    return self;
}

@end
