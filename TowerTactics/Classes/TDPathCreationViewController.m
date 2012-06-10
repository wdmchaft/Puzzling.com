//
//  TDPuzzleCreationViewController.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 5/8/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDPathCreationViewController.h"
#import "mainview.h"
#import "TDPuzzleFinalizerViewController.h"

@interface TDPathCreationViewController() {  
}
-(void) drawSelectionSquares;
-(void) updateBasedOnSelection;
-(void) setupFirstSelection;

@end

@implementation TDPathCreationViewController
@synthesize enemies, introPage, nextButton,testButton, nextPage;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        curSelection = nil;
        savedViews = [[NSArray alloc] initWithArray:self.view.subviews];
        [self setupFirstSelection];
        cells = [[NSMutableArray alloc] init];
        [self drawSelectionSquares];
    }
    return self;
}

bool isCorner(int row, int col){
    return ((row == 0 && col == NUM_COLS - 1) ||
            (row == NUM_ROWS - 1 && col == NUM_COLS - 1) ||
            (row == 0 && col == 0) ||
            (row == NUM_ROWS - 1 && col == 0));
}

-(void) setupFirstSelection{
    for(int row = 0; row < NUM_ROWS; row ++){
        for( int col = 0; col < NUM_COLS; col ++){
            if((row == 0 || row == NUM_ROWS - 1 || col == 0 || col == NUM_COLS - 1) && !isCorner(row,col)){
                allowsSelection[row][col] = true;
            }else{
                allowsSelection[row][col] = false;
            }
        }
    }
    
}

-(void) drawSelectionSquares{
    for (UIView *view in self.view.subviews) {
        if(![savedViews containsObject:view])
            [view removeFromSuperview];
    }
    [self setupPathWithCells:cells];
    [self drawBackground];
    for(int row =0; row < NUM_ROWS; row ++){
        for( int col = 0; col < NUM_COLS; col ++){
            UIImage * image;
            if(curSelection && curSelection.row == row && curSelection.col == col){
                image = [ UIImage imageNamed:@"red_select.png"];
                UIImageView* iv = [[UIImageView alloc] initWithImage:image];
                [iv setFrame: CGRectMake(col*40, row*40, 40, 40)];
                iv.alpha = .5;
                [self.view addSubview:iv];
                [self.view bringSubviewToFront:iv];
                [iv release];
            }else if(allowsSelection[row][col]){
                if(curSelection && (row == 0 || row == NUM_ROWS - 1 || col == 0 || col == NUM_COLS - 1)){
                    image = [ UIImage imageNamed:@"green_select.png"];
                }
                else{
                    image = [ UIImage imageNamed:@"blue_select.png"];
                }
                UIImageView* iv = [[UIImageView alloc] initWithImage:image];
                [iv setFrame: CGRectMake(col*40, row*40, 40, 40)];
                iv.alpha = .5;
                [self.view addSubview:iv];
                [self.view bringSubviewToFront:iv];
                [iv release];
                
            }
        }
    }
}

-(bool) nextShouldBeEnabled{
    if([cells count] < 2)
        return false;
    Cell * last = [cells lastObject];
    return [last row] == 0 || [last row] == NUM_ROWS - 1 || [last col] == 0 || [last col] == NUM_COLS - 1;
}

-(void)touchAtRow:(int)row Col:(int)col{
    if(row < NUM_ROWS){
        if(allowsSelection[row][col]){
            if(curSelection && row == curSelection.row && col == curSelection.col){
                [cells removeObject:curSelection];
                if([cells count] > 0){
                    curSelection = [cells lastObject];
                    [self updateBasedOnSelection];
                }else{
                    [self setupFirstSelection];
                    curSelection = nil;
                }
            }else{
                curSelection = [[[Cell alloc] initWithRow:row Col:col]autorelease];
                [cells addObject:curSelection];
                [self updateBasedOnSelection];
            }
            [self drawSelectionSquares];
        } 
    }
    bool enabled = [self nextShouldBeEnabled];
    [nextButton setEnabled:enabled];
    [testButton setEnabled:enabled];
    
}

-(void) updateBasedOnSelection{
    for(int row =0; row < NUM_ROWS; row ++){
        for( int col = 0; col < NUM_COLS; col ++){
            if((row == curSelection.row && row != 0  && row != NUM_ROWS-1) || (col == curSelection.col && col != 0  && col != NUM_COLS-1)){
                if([cells count] >= 2){
                    Cell* prev = [cells objectAtIndex:[cells count]-2];
                    if(prev.row == curSelection.row){
                        if(prev.col < curSelection.col){
                            if(col >=curSelection.col){
                                allowsSelection[row][col] = true;
                            }else{
                                allowsSelection[row][col] = false;
                            }
                        }else{
                            if(col <= curSelection.col){
                                allowsSelection[row][col] = true;
                            }else{
                                allowsSelection[row][col] = false;
                            }
                        }
                    }else{
                        if(prev.row < curSelection.row){
                            if(row >=curSelection.row){
                                allowsSelection[row][col] = true;
                            }else{
                                allowsSelection[row][col] = false;
                            }
                        }else{
                            if(row <= curSelection.row){
                                allowsSelection[row][col] = true;
                            }else{
                                allowsSelection[row][col] = false;
                            }
                        }
                    }
                }else allowsSelection[row][col] = true;
            }else{
                allowsSelection[row][col] = false;
            }
        }
    }
}

-(IBAction)back{
    [introPage dismissModalViewControllerAnimated:NO];
}

-(IBAction)test{
    mainview *mv = [[mainview alloc] initWithNibName:@"Final_ProjectViewController" bundle:[NSBundle mainBundle] cells:cells enemies:self.enemies money:300];
    mv.introPage = self;
    [self presentModalViewController:mv animated:NO];
}

-(IBAction)next{
    TDPuzzleFinalizerViewController* mv = (TDPuzzleFinalizerViewController*)self.nextPage;
    if(!mv){
        mv = [[TDPuzzleFinalizerViewController alloc] initWithNibName:@"TDPuzzleFinalizerViewController" bundle:[NSBundle mainBundle]];
        self.nextPage = mv;
        [mv autorelease];
    }
    mv.introPage = self;
    mv.enemies = self.enemies;
    mv.cells = [Cell cellArraySerialize:cells];
    [self presentModalViewController:self.nextPage animated:NO];
}

-(void)dealloc{
    [cells release];
    [savedViews release];
    [super dealloc];
}

@end
