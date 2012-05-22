//
//  UserPuzzlesViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/14/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "UserPuzzlesViewController.h"
#import "UserPuzzleCell.h"
#import "PuzzleSDK.h"
#import "PuzzleModel.h"
#import "PuzzleCurrentUser.h"
#import "PlayOwnPuzzleViewControllerViewController.h"
#import "PuzzleModel.h"


@interface UserPuzzlesViewController () {
	NSArray *__tactics;
	UIActivityIndicatorView *__activityView;
}

@property (nonatomic, readwrite, retain) NSArray *tactics;
@property (nonatomic, readwrite, retain) UIActivityIndicatorView *activityView;

@end

@implementation UserPuzzlesViewController

@synthesize tactics = __tactics, activityView = __activityView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"My Puzzles";

    [[PuzzleSDK sharedInstance] getPuzzlesMadeByUser:[PuzzleCurrentUser currentUser].userID onCompletion:^(PuzzleAPIResponse response, NSArray *puzzles) {
		if (response == PuzzleOperationSuccessful) {
			if ([puzzles count] == 0) {
				[[[[UIAlertView alloc] initWithTitle:@"No Puzzles" message:@"You don't have any tactics live on the server. It is possible one of your tactics was removed because it had a problem." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			}
			self.tactics = puzzles;
			[self.tableView reloadData];
		} else {
			[PuzzleErrorHandler presentErrorForResponse:response];
		}
	}];
}

- (void)dealloc {
	[__tactics release];
	__tactics = nil;
	[__activityView release];
	__activityView = nil;
	
	[super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tactics count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UserPuzzleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserPuzzleCell" owner:nil options:nil];
		
		for (id currentObject in topLevelObjects)
		{
			if ([currentObject isKindOfClass:[UserPuzzleCell class]])
			{
				cell = (UserPuzzleCell *)currentObject;
				break;
			}
		}
	}
	
    PuzzleModel *tactic = [self.tactics objectAtIndex:indexPath.row];
    [cell setName:tactic.name];
	[cell setRating:tactic.rating];
	[cell setTaken:tactic.taken];
	[cell setLikes:tactic.likes];
	[cell setDislikes:tactic.dislikes];
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	self.activityView.center = self.view.center;
	self.view.userInteractionEnabled = NO;
	[self.activityView startAnimating];
	[self.view addSubview:self.activityView];
    [[PuzzleSDK sharedInstance] getPuzzle:((PuzzleModel *)[self.tactics objectAtIndex:indexPath.row]).puzzleID onCompletion:^(PuzzleAPIResponse response, PuzzleModel *puzzle) {
		if (response == PuzzleOperationSuccessful) {
			PlayOwnPuzzleViewControllerViewController *vc = [[[PlayOwnPuzzleViewControllerViewController alloc] init] autorelease];
			vc.puzzleModel = puzzle;
			[self.navigationController pushViewController:vc animated:YES];
		} else {
			[PuzzleErrorHandler presentErrorForResponse:response];
		}
		[self.activityView stopAnimating];
		[self.activityView removeFromSuperview];
		self.activityView = nil;
		self.view.userInteractionEnabled = YES;
	}];
}

@end
