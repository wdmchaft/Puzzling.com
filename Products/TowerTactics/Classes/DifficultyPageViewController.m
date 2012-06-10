//
//  DifficultyPageViewController.m
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "DifficultyPageViewController.h"
#import "IntroPageViewController.h"


@implementation DifficultyPageViewController
@synthesize introPage;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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

-(IBAction)setDifficulty1 {
	mainview *mv = [[mainview alloc] initWithNibName:@"Final_ProjectViewController" bundle:[NSBundle mainBundle] path:@"easy" enemies:nil];
	mv.introPage = self;
	[self presentModalViewController:mv animated:YES];
//	[introPage dismissCurrentVC];
//	[introPage setDifficultyString:@"easy"];
	//[introPage beginGame];
}
-(IBAction)setDifficulty2 {
	mainview *mv = [[mainview alloc] initWithNibName:@"Final_ProjectViewController" bundle:[NSBundle mainBundle] path:@"default" enemies:nil];
	mv.introPage = self;
	[self presentModalViewController:mv animated:YES];
	//[introPage dismissCurrentVC];
//	[introPage setDifficultyString:@"default"];
//	[introPage beginGame];
}
-(IBAction)setDifficulty3 {
	mainview *mv = [[mainview alloc] initWithNibName:@"Final_ProjectViewController" bundle:[NSBundle mainBundle] path:@"tough" enemies:nil];
	mv.introPage = self;
	[self presentModalViewController:mv animated:YES];
//	[introPage dismissCurrentVC];
//	[introPage setDifficultyString:@"tough"];
//	[introPage beginGame];
}
-(IBAction)setDifficulty4 {
	mainview *mv = [[mainview alloc] initWithNibName:@"Final_ProjectViewController" bundle:[NSBundle mainBundle] path:@"impossible" enemies:nil];
	mv.introPage = self;
	[self presentModalViewController:mv animated:YES];
//	[introPage dismissCurrentVC];
//	[introPage setDifficultyString:@"impossible"];
//	[introPage beginGame];
}
-(IBAction)setDifficulty5 {
	mainview *mv = [[mainview alloc] initWithNibName:@"Final_ProjectViewController" bundle:[NSBundle mainBundle] path:@"suicide" enemies:nil];
	mv.introPage = self;
	[self presentModalViewController:mv animated:YES];
//	[introPage dismissCurrentVC];
//	[introPage setDifficultyString:@"suicide"];
//	[introPage beginGame];
}


-(IBAction)goBack {
	[introPage dismissCurrentVC];
}


- (void)dealloc {
    [super dealloc];
}


@end
