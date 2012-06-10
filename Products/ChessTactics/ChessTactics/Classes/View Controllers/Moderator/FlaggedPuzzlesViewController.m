//
//  FlaggedPuzzlesViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/26/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "FlaggedPuzzlesViewController.h"
#import "UserPuzzleCell.h"
#import "PuzzleSDK.h"
#import "PuzzleModel.h"
#import "PuzzleCurrentUser.h"
#import "PlayPuzzleModerateViewController.h"
#import "PuzzleModel.h"
#import "ConstantsForUI.h"


@interface FlaggedPuzzlesViewController (){
	NSArray *__tactics;
	UIActivityIndicatorView *__activityView;
}

@property (nonatomic, readwrite, retain) NSArray *tactics;
@property (nonatomic, readwrite, retain) UIActivityIndicatorView *activityView;

@end

@implementation FlaggedPuzzlesViewController

@synthesize tactics = __tactics, activityView = __activityView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Flagged Puzzles";
	self.view.backgroundColor = BACKGROUND_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[PuzzleSDK sharedInstance] getFlaggedPuzzlesOnCompletion:^(PuzzleAPIResponse response, NSArray *puzzles) {
		if (response == PuzzleOperationSuccessful) {
			if ([puzzles count] == 0) {
				[[[[UIAlertView alloc] initWithTitle:@"No Puzzles" message:@"There are no puzzles currently flagged for removal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
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
			PlayPuzzleModerateViewController *vc = [[[PlayPuzzleModerateViewController alloc] init] autorelease];
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
