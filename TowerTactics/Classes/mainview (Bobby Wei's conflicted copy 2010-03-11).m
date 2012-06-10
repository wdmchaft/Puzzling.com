//
//  Final_ProjectViewController.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/7/10.
//  Copyright Stanford 2010. All rights reserved.
//

#import "mainview.h"
#import "TDRunLoop.h"
#include "ConvenienceMethods.h"
#import "TDEnemy.h"
@implementation mainview

-(void) drawBackGround{
	path = [[TDPath alloc] initWithPList:@"default"];
	BOOL isPath[12][8];
	for(int i = 0; i< 12; i++)
		for(int j = 0; j < 8; j++)
			isPath[i][j] = FALSE;
	NSArray * cells = [path getCells];
	cell * last = [cells objectAtIndex:0];
	for(int i = 1; i < [cells count]; i++ ){
		cell * current = [cells objectAtIndex:i];
		if(current.row == last.row){
			for(int i = min(current.col, last.col); i <=max(current.col, last.col); i++) 
				isPath[last.row][i] = TRUE;
		}else{
			for(int i = min(current.row, last.row); i <=max(current.row, last.row); i++) 
				isPath[i][last.col] = TRUE;
		}
			
		last = current;
	}
	for(int i =0; i < 8; i ++){
		for( int j = 0; j < 11; j ++){
			UIImage * image;
			if(!isPath[j][i]){
				int random = arc4random() % 3;
				image = [ UIImage imageNamed:
						 [NSString stringWithFormat:@"grass%d.png", random]];
			}else {
				image = [ UIImage imageNamed:@"path.png"];
			}
			UIImageView * iv = [[UIImageView alloc] initWithImage:image];
			[iv setFrame: CGRectMake(i*40, j*40, 40, 40)];
			[self.view addSubview:iv];
			[self.view bringSubviewToFront:iv];
			[iv release];
		}
	}
	UIImage * image = [UIImage imageNamed:@"statusbar.png"];
	UIImageView * iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(0, 440, 320, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
	for(int i = 0; i < 5; i++){
		image = [UIImage imageNamed:[NSString stringWithFormat:@"t%d-0.png", i]];
		UIImageView * iv = [[UIImageView alloc] initWithImage:image];
		[iv setFrame: CGRectMake(i*40, 440, 40, 40)];
		[self.view addSubview:iv];
		[self.view bringSubviewToFront:iv];
		[iv release];
	}
	image = [UIImage imageNamed:@"play.png"];
	iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(5*40, 440, 40, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
	image = [UIImage imageNamed:@"upgrade.png"];
	iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(6*40, 440, 40, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
	image = [UIImage imageNamed:@"sell.png"];
	iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(7*40, 440, 40, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self drawBackGround];
		TDRunLoop * mainRun = [[TDRunLoop alloc] initWithMV:self];
		[mainRun run:path];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"%d,%d", (int) [[touches anyObject] locationInView:self.view].x /40,
					(int) [[touches anyObject] locationInView:self.view].y /40 );

}


- (void)dealloc {
	[path release];
    [super dealloc];
}

@end
