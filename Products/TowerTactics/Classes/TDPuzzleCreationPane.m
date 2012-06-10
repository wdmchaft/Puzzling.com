//
//  TDPuzzleCreationPane.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/3/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDPuzzleCreationPane.h"

@implementation TDPuzzleCreationPane
@synthesize introPage,nextButton,nextPage;

-(IBAction)back{
    [self.introPage dismissModalViewControllerAnimated:NO];
}

-(IBAction)next{
    //overrride
}
@end
