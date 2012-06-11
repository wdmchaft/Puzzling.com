//
//  IntroPageViewController.m
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "IntroPageViewController.h"
#import "PuzzleSDK.h"
#import "PuzzleModel.h"
#import "PuzzleCurrentUser.h"

@implementation IntroPageViewController
@synthesize ratingLabel;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//    [[PuzzleSDK sharedInstance] createApp:@"TowerTactics" onCompletion:^(PuzzleAPIResponse response, id data) {
//            if(response != PuzzleOperationSuccessful){
//                [PuzzleErrorHandler presentErrorForResponse:response];
//            }else{
//                NSLog(@"app created");
//            }
//        }
//     ];
	//titleLine.font = [UIFont fontWithName:@"Zapfino" size:22.0];
}

-(void) viewWillAppear:(BOOL)animated{
    PuzzleCurrentUser* user = [PuzzleCurrentUser currentUser];
    if(user){
        ratingLabel.text = [NSString stringWithFormat:@"%@'s rating: %d", user.username, user.rating];
    }
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)beginGame {
	mv = [[mainview alloc] initWithNibName:@"Final_ProjectViewController" bundle:[NSBundle mainBundle] path:difficultyString enemies:nil];
	mv.introPage = self;
	[self presentModalViewController:mv animated:YES];
	NSLog(@"Does it recognize this method??");
}

-(IBAction)getInstructions {
	instructions = [[TDEnemyChooserViewController alloc] initWithNibName:@"TDEnemyChooserViewController" bundle:[NSBundle mainBundle]];
	instructions.introPage = self;
	[self presentModalViewController:instructions animated:YES];
}

-(IBAction)getInfo {
	info = [[InstructionPageViewController alloc] initWithNibName:@"InstructionPageViewController" bundle:[NSBundle mainBundle]];
	info.introPage = self;
	[self presentModalViewController:info animated:YES];
}

-(void)dismissCurrentVC {
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)play {
    [[PuzzleSDK sharedInstance] getPuzzleForCurrentUserOnCompletion:^(PuzzleAPIResponse response, id data) {
        if(response != PuzzleOperationSuccessful){
           [PuzzleErrorHandler presentErrorForResponse:response];
        }else{
            NSDictionary* puzzleDictionary = ((PuzzleModel*)data).setupData;
            mainview *vc = [[mainview alloc] initWithNibName:@"Final_ProjectViewController" bundle:[NSBundle mainBundle] cells:[Cell cellArrayUnserialize:[puzzleDictionary objectForKey:@"cells"]] enemies:[puzzleDictionary objectForKey:@"enemies"] money:[[puzzleDictionary objectForKey:@"money"] intValue]];
            vc.introPage = self;
            vc.puzzleID = ((PuzzleModel*)data).puzzleID;
            vc.puzzleName = ((PuzzleModel*)data).name;

            [self presentModalViewController:vc animated:NO];
        }
    }];

//	difficulty = [[DifficultyPageViewController alloc] initWithNibName:@"DifficultyPageViewController" bundle:[NSBundle mainBundle]];
//	difficulty.introPage = self;
//	[self presentModalViewController:difficulty animated:YES];
}

-(IBAction)getDifficulty {
	difficulty = [[DifficultyPageViewController alloc] initWithNibName:@"DifficultyPageViewController" bundle:[NSBundle mainBundle]];
	difficulty.introPage = self;
	[self presentModalViewController:difficulty animated:YES];
}

-(void)setDifficultyString:(NSString *)d {
	difficultyString = d;
}

- (void)dealloc {
	[mv release];
	[instructions release];
    [super dealloc];
}


@end
