//
//  TDTextField.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/3/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDTextField.h"

@interface TDTextField()
-(void) setUp;
@end

@implementation TDTextField

-(void) setup{
    UIFont * font = [UIFont fontWithName:@"Eraser" size:self.font.pointSize];
    if(font != nil) 
        self.font = font;
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.borderStyle = UITextBorderStyleRoundedRect;

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
