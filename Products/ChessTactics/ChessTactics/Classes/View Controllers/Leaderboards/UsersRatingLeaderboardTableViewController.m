//
//  UsersRatingLeaderboardTableViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/23/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "UsersRatingLeaderboardTableViewController.h"
#import "PuzzleUser.h"
#import "PuzzleSDK.h"
#import "PuzzleErrorHandler.h"
#import "ConstantsForUI.h"


@interface UsersRatingLeaderboardTableViewController ()
{
	NSArray *__users;
}

@property (nonatomic, readwrite, retain) NSArray *users;

@end

@implementation UsersRatingLeaderboardTableViewController

@synthesize users = __users;

- (void)viewDidLoad
{	
    [super viewDidLoad];
	
	self.title = @"Top 20 Rated Users";
	self.view.backgroundColor = BACKGROUND_COLOR;
	
	[[PuzzleSDK sharedInstance] getLeaderboardForUsersOnCompletion:^(PuzzleAPIResponse response, NSArray *users) {
		if (response == PuzzleOperationSuccessful)
		{
			self.users = users;
			[self.tableView reloadData];
		}
		else
		{
			[PuzzleErrorHandler presentErrorForResponse:response];
		}
	}];
}

- (void)dealloc
{
	[__users release];
	__users = nil;
	
	[super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
	}
	
	PuzzleUser *user = [self.users objectAtIndex:indexPath.row];
	cell.textLabel.text = user.username;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Rating: %d", user.rating];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UIView *backgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
	backgroundView.backgroundColor = BACKGROUND_COLOR;
	cell.backgroundView = backgroundView;
	
    return cell;
}

@end
