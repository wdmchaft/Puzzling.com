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
		case 3:
			puzzleID = @"4fc4554737f1dd7a4500002a"; //NxD7
			break;
		case 0:
			puzzleID = @"4fc45724575cd5ce46000012"; //rook-pawn mate
			break;
		case 2:
			puzzleID = @"4fc458be575cd5ce46000016"; //Pawn pinned. Mate 2
			break;
		case 4:
			puzzleID = @"4fc45b8c575cd5ce4600002d"; //Queen fork
			break;
		case 1:
			puzzleID = @"4fc45dbc575cd5ce4600005b"; //Rook pinned and taken
			break;
		default:
			puzzleID = nil;
			break;
	}
	
	self.puzzleID = puzzleID;
	
	[super viewDidLoad];
}

- (void)presentNextTactic
{
	if (self.puzzleNumber >= 4)
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
