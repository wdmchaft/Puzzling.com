//
//  TDBackgroundViewController.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 5/8/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDBackgroundViewController.h"

@implementation TDBackgroundViewController


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self drawBackground];
        for(int i = 0; i< NUM_COLS; i++)
            for(int j = 0; j < NUM_ROWS; j++)
                isPath[i][j] = FALSE;
    }
    return self;
}

-(void) drawBackground{
    srand(0);//consistant, random looking bg
    for(int i =0; i < 8; i ++){
        for( int j = 0; j < 11; j ++){
            UIImage * image;
            int random = rand() % 3;
            image = [ UIImage imageNamed:
                     [NSString stringWithFormat:@"grass%d.png", random]];
            UIImageView * iv = [[UIImageView alloc] initWithImage:image];
            [iv setFrame: CGRectMake(i*40, j*40, 40, 40)];
            [self.view addSubview:iv];
            [self.view bringSubviewToFront:iv];
            [iv release];
        }
    }
    for(int i =0; i < NUM_COLS; i ++){
		for( int j = 0; j < NUM_ROWS; j ++){
			if(isPath[j][i]){
                UIImage * image = [ UIImage imageNamed:@"path.png"];
                UIImageView* iv = [[UIImageView alloc] initWithImage:image];
                [iv setFrame: CGRectMake(i*40, j*40, 40, 40)];
                [self.view addSubview:iv];
                [self.view bringSubviewToFront:iv];
                [iv release];
            }
		}
	}
    
}

-(void) setupPathWithCells:(NSArray*)cells{
    for(int i =0; i < NUM_COLS; i ++)
		for( int j = 0; j < NUM_ROWS; j ++)
            isPath[j][i] = false;
    if([cells count] > 0){
        Cell * last = [cells objectAtIndex:0];
        for(int i = 1; i < [cells count]; i++ ){
            Cell * current = [cells objectAtIndex:i];
            if(current.row == last.row){
                for(int i = min(current.col, last.col); i <=max(current.col, last.col); i++) 
                    isPath[last.row][i] = TRUE;
            }else{
                for(int i = min(current.row, last.row); i <=max(current.row, last.row); i++) 
                    isPath[i][last.col] = TRUE;
            }
            
            last = current;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    int col = gridSnap((int) [[touches anyObject] locationInView:self.view].x);
    int row = gridSnap((int) [[touches anyObject] locationInView:self.view].y);
    [self touchAtRow:row Col:col];
    
}

-(void)touchAtRow:(int)row Col:(int)col{
    //nothing here
}

@end
