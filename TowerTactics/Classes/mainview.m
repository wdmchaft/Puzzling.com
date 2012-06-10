//
//  Final_ProjectViewController.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/7/10.
//  Copyright Stanford 2010. All rights reserved.
//

#import "mainview.h"
#import "TDRunLoop.h"

#import "TDEnemy.h"
#import "TDTower.h"
#import "TDPuzzleCompletionViewController.h"
#import "PuzzleSDK.h"

@interface mainview(){
}
-(void)setupUI;
@end

@implementation mainview
@synthesize towerSelected;
@synthesize introPage, puzzleID,puzzleName;

-(void) drawBackGround:(NSString*)pathName{
	path = [[TDPath alloc] initWithPList:pathName];
	
	NSArray * cells = [path getCells];
	
    [self setupPathWithCells:cells];
	
    [self drawBackground];
    
    [self setupUI];
}

-(void) drawBackGroundWithCells:(NSArray*)cells{
    path = [[TDPath alloc] initWithCells:cells];
	
	//NSArray * cells = [path getCells];
	
    [self setupPathWithCells:cells];
	
    [self drawBackground];
    
    [self setupUI];

}

-(void) setupUI{
    UIImage * image = [UIImage imageNamed:@"statusbar.png"];
	UIImageView * iv = [[UIImageView alloc] initWithImage:image];
	[iv setFrame: CGRectMake(0, 440, 320, 40)];
	[self.view addSubview:iv];
	[self.view bringSubviewToFront:iv];
	[iv release];
	
	UIImage *temp = [UIImage imageNamed:@"selector.png"];
	selectedButton = [[UIImageView alloc] initWithImage:temp];
	[selectedButton setFrame: CGRectMake(0, 440, 40, 40)];
	[self.view addSubview:selectedButton];
	[self.view bringSubviewToFront:selectedButton];
	
	for(int i = 0; i < 5; i++){
		image = [UIImage imageNamed:[NSString stringWithFormat:@"t%d-0.png", i]];
		UIImageView * iv = [[UIImageView alloc] initWithImage:image];
		[iv setFrame: CGRectMake(i*40, 440, 40, 40)];
		[self.view addSubview:iv];
		[self.view bringSubviewToFront:iv];
		[iv release];
	}
	image = [UIImage imageNamed:@"play.png"];
	playButton = [[UIImageView alloc] initWithImage:image];
	[playButton setFrame: CGRectMake(5*40, 440, 40, 40)];
	[self.view addSubview:
	 playButton];
	[self.view bringSubviewToFront:playButton];
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
	
    status = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status.png"]];
	[status setFrame: CGRectMake(0, 0, 320, 30)];
	[self.view addSubview:status];
	[self.view bringSubviewToFront:status];
	
    kills = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 15)];
	[kills setBackgroundColor:[UIColor clearColor]];
	[kills setTextColor:[UIColor whiteColor]];
	kills.text = @"0/0";
	[self.view addSubview:kills];
	[self.view bringSubviewToFront:kills];
    
	lives = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 60, 15)];
	[lives setBackgroundColor:[UIColor clearColor]];
	[lives setTextColor:[UIColor whiteColor]];
	lives.text = @"0";
	[self.view addSubview:lives];
	[self.view bringSubviewToFront:lives];
	
	money = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 60, 15)];
	[money setBackgroundColor:[UIColor clearColor]];
	[money setTextColor:[UIColor whiteColor]];
	money.text = @"0";
	[self.view addSubview:money];
	[self.view bringSubviewToFront:money];
    
    quit = [[UIButton alloc] initWithFrame:CGRectMake((320 - 125)/2,(480 - 50)/2, 125, 50)];
    [quit setImage:[UIImage imageNamed:@"back_button_shaded.png"] forState:UIControlStateNormal];
    [quit setAlpha:0];
    [quit setEnabled:NO];
    [quit addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:quit];
    [self.view bringSubviewToFront:quit];
    
	
	failure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failure.png"]];
	[failure setFrame: CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:failure];
	[failure setAlpha:0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil path:(NSString*)pathName enemies:(NSArray*)enemies{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self drawBackGround:pathName];
		victoried = FALSE;
		mainRun = [[TDRunLoop alloc] initWithMV:self money:300];
		[(TDRunLoop*) mainRun run:path enemies:enemies];
    }
	[self initializeVariables];
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cells:(NSArray*)c enemies:(NSArray*)enemies money:(int)startingMoney{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        if(startingMoney == 0) startingMoney = 300;
		[self drawBackGroundWithCells:c];
		victoried = FALSE;
		mainRun = [[TDRunLoop alloc] initWithMV:self money:startingMoney];
		[(TDRunLoop*) mainRun run:path enemies:enemies];
    }
	[self initializeVariables];
    return self;
}

-(void)touchAtRow:(int)row Col:(int)col{
	if([mainRun getLives] > 0 && !victoried){
		if (row == 11) { // Selected menu
			if (col < 5) { // Tower selected
				towerSelected = col;
				sellingMode = NO;
				levelupMode = NO;
				[self select:col];
			} else if (col == 5) { // Play/pause
				if (playMode == YES) {
					[mainRun pause];
					playMode = NO;
                    [quit setAlpha:1.0];
                    [self.view bringSubviewToFront:quit];
                    [quit setEnabled:YES];
				} else {
					[mainRun playAgain];
					playMode = YES;
                    [quit setAlpha:0];
                    [quit setEnabled:NO];
				}
			} else if (col == 6) { // Level up!
				levelupMode = YES;
				sellingMode = NO;
				[self select:col];
			} else if (col == 7) { // Sell tower
				sellingMode = YES;
				levelupMode = NO;
				[self select:col];
			}
		} else { // Add tower
			if (sellingMode == NO && levelupMode == NO && ([mainRun hasTowerInCol:col andRow:row] == NO) && !isPath[row][col] == YES) {
				[mainRun addTower:col withRow:row towerType:towerSelected];
			} else if (sellingMode == YES && [mainRun hasTowerInCol:col andRow:row] == YES) {
				[mainRun sellTower:col withRow:row];
			} else if (levelupMode == YES && [mainRun hasTowerInCol:col andRow:row] == YES) {
				[mainRun levelUp:col withRow:row];
			}
		}
	}
	else{
        [self dismissSelf];
    }
}

-(void) setStatusWithLives:(int)l Money:(int)m Kills:(int)k ofTotal:(int)total{
	money.text = [NSString stringWithFormat:@"%d", m];
	lives.text = [NSString stringWithFormat:@"%d", l];
    kills.text = [NSString stringWithFormat:@"%d/%d", k,total];
    score = ((float)k)/total;
}


- (void)initializeVariables {
	towerSelected = 0; // Default tower
	currentLevel = 0; // Starting level
	sellingMode = NO;
	playMode = NO;
	levelupMode = NO;
}

-(void) pause{
	[playButton setImage:[UIImage imageNamed:@"play.png"]];
}

-(void) play{
	[playButton setImage:[UIImage imageNamed:@"pause.png"]];
}
-(void) failure{
	if(failure.alpha < 1) failure.alpha += .01;
	else failure.alpha = 1;
}

-(void) victory{
	if(failure.alpha == 0){
		victoried = TRUE;
		[failure setImage:[UIImage imageNamed: @"flag.png"]];
		[failure setFrame: CGRectMake(13, 50, 297, 287)];
		[self.view bringSubviewToFront:failure];
        if(self.puzzleID != nil){
            [[PuzzleSDK sharedInstance] takePuzzle:self.puzzleID score:score rated:NO onCompletion:^(PuzzleAPIResponse response, id data) {
                if(response != PuzzleOperationSuccessful)
                    [PuzzleErrorHandler presentErrorForResponse:response];
                else{
                    TDPuzzleCompletionViewController* puzzlevc = [[TDPuzzleCompletionViewController alloc] initWithNibName:@"TDPuzzleCompletionViewController" bundle:[NSBundle mainBundle]];
                    puzzlevc.score = score;
                    puzzlevc.introView = self;
                    [self.view addSubview:puzzlevc.view];
                    //[puzzlevc release];
                }
            }];
        }
    }
	if(failure.alpha < 1) failure.alpha+=.01;
	else failure.alpha = 1;
}

-(void) dismissSelf{
	[introPage dismissModalViewControllerAnimated:YES];
}

-(void) select:(int)col {
	[selectedButton setFrame: CGRectMake(col*40, 440, 40, 40)];	
}

- (void)dealloc {
	[failure release];
	[playButton release];
	[lives release];
	[money release];
    [kills release];
	[status release];
	[path release];
	[super dealloc];
}

@end
