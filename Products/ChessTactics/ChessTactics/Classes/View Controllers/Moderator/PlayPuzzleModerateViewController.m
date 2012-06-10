//
//  PlayPuzzleModerateViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/26/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "PlayPuzzleModerateViewController.h"
#import "PuzzleModel.h"
#import "PuzzleErrorHandler.h"
#import "EnterExplanationViewController.h"
#import "TacticsDataConstants.h"


#define DELETE_PUZZLE @"Delete Puzzle"
#define REMOVE_FLAG @"Remove Flag - Puzzle OK"

@interface PlayPuzzleModerateViewController () <UIActionSheetDelegate, EnterExplanationViewControllerDelegate>

@end

@implementation PlayPuzzleModerateViewController

- (id)init
{
	self = [super initWithNibName:@"PlayPuzzleViewController" bundle:nil];
	return self;
}

- (IBAction)menuPressed:(id)sender
{
	UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:DELETE_PUZZLE, REMOVE_FLAG, nil] autorelease];
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:DELETE_PUZZLE])
	{
		EnterExplanationViewController *vc = [[[EnterExplanationViewController alloc] init] autorelease];
		vc.delegate = self;
		[self.navigationController pushViewController:vc animated:YES];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:REMOVE_FLAG])
	{
		[[PuzzleSDK sharedInstance] deflagPuzzle:self.puzzleModel.puzzleID onCompletion:^(PuzzleAPIResponse response, id data) {
			if (response == PuzzleOperationSuccessful)
			{
				[[[[UIAlertView alloc] initWithTitle:@"Flag Removed" message:@"You verified that this puzzle should not have been flagged." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			}
			else
			{
				[PuzzleErrorHandler presentErrorForResponse:response];
			}
		}];
	}
}

- (void)enterExplanationViewController:(EnterExplanationViewController *)vc didEnterExplanation:(NSString *)explanation
{
	if (!explanation)
	{
		[[[[UIAlertView alloc] initWithTitle:@"Please Enter an Explanation" message:@"Enter a good explanation so that the user may learn to make better tactics." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	NSMutableDictionary *newSolution = [NSMutableDictionary dictionaryWithDictionary:self.puzzleModel.solutionData];
	[newSolution setValue:explanation forKey:REMOVED_EXPLANATION];
	if (self.puzzleModel.puzzleID)
	{
		[[PuzzleSDK sharedInstance] createPuzzleWithType:nil name:nil setupData:nil solutionData:newSolution isUpdate:self.puzzleModel.puzzleID onCompletionBlock:^(PuzzleAPIResponse response, id data) {
			//do nothing
		}];
	}
	[[PuzzleSDK sharedInstance] deletePuzzle:self.puzzleModel.puzzleID onCompletion:^(PuzzleAPIResponse response, id data) {
		if (response == PuzzleOperationSuccessful)
		{
			[[[[UIAlertView alloc] initWithTitle:@"Puzzle Removed" message:@"The puzzle has been removed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}
		else
		{
			[PuzzleErrorHandler presentErrorForResponse:response];
		}
	}];
}

@end
