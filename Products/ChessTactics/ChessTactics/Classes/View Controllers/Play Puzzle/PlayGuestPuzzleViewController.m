//
//  PlayGuestPuzzleViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/25/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PlayGuestPuzzleViewController.h"


@interface PlayGuestPuzzleViewController () {
	int __puzzleNumber;
}

@end

@implementation PlayGuestPuzzleViewController

@synthesize puzzleNumber = __puzzleNumber;

- (id)init
{
	self = [super initWithRated:NO];
	if (self)
	{
		self.puzzleNumber = 0;
	}
	return self;
}

- (void)viewDidLoad
{
	NSString *puzzleID = nil;
	switch (self.puzzleNumber)
	{
		case 0:
			puzzleID = @"4fb6985b873536f7fe000051";
			break;
		case 1:
			puzzleID = @"4fb28825ecac992fc2000036";
			break;
		case 2:
			puzzleID = @"4fc02384b25f091f110001d4";
			break;
		default:
			break;
	}
	
	self.puzzleID = puzzleID;
	
	[super viewDidLoad];
}

- (void)presentNextTactic
{
	if (self.puzzleNumber >= 2)
	{
		[[[[UIAlertView alloc] initWithTitle:@"That's all" message:@"Sorry, that's all we have for guests. Sign up for all our tactics, the ability to create your own, and get a tactics rating." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		PlayGuestPuzzleViewController *newTacticVC = [[[PlayGuestPuzzleViewController alloc] init] autorelease];
		newTacticVC.puzzleNumber = self.puzzleNumber + 1;
		UINavigationController *tempController = self.navigationController;
		[[self retain] autorelease]; //so that this vc doesn't get dealloced
		[self.navigationController popViewControllerAnimated:NO];
		[tempController pushViewController:newTacticVC animated:YES];
	}
}

- (void)endTactic:(double)score
{
	[super endTactic:score];
	self.bottomLabel.hidden = YES; //Shouldn't show anything here
}

- (IBAction)showCommentPressed:(id)sender
{
	[[[[UIAlertView alloc] initWithTitle:@"Please Register" message:@"You can only view comments if you login." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

@end
