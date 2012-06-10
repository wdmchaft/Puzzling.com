//
//  TDPuzzleCompletionViewController.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/5/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDPuzzleCompletionViewController.h"
#import "mainview.h"

@implementation TDPuzzleCompletionViewController
@synthesize score, scoreLabel,introView;


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    scoreLabel.text = [NSString stringWithFormat:@"%d%/100",(int)(100*score)];

    CGRect endFrame = self.view.frame;
    CGRect startFrame = self.view.frame;
    startFrame.origin.y += 500;
    
    self.view.frame = startFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.view.frame = endFrame;
    
    [UIView commitAnimations];
    
}

-(IBAction) dismissSelf{
    [self.view removeFromSuperview];
    [self release];
}
@end
