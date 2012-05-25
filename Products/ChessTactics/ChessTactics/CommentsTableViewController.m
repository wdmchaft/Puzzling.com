//
//  RootViewController.m
//  SMS Bubbles
//
//  Created by Cedric Vandendriessche on 17/07/10.
//  Copyright FreshCreations 2010. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "PuzzleComment.h"
#import "PuzzleCurrentUser.h"
#import "PuzzleErrorHandler.h"

@interface CommentsTableViewController() {
	PuzzleID *__puzzleID;
}

- (void)reloadData;
- (void)closeKeyboard;

@end

@implementation CommentsTableViewController

@synthesize tbl, field, toolbar, messages;
@synthesize puzzleID = __puzzleID;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Comments";
	
	[self reloadData];
	
	UITapGestureRecognizer *tapGR = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)] autorelease];
	[self.tbl addGestureRecognizer:tapGR];
	
	/*
	 Set the background color
	 */
	self.tbl.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
	self.toolbar.tintColor = [UIColor blackColor];
}

- (void)closeKeyboard
{
	[self textFieldShouldReturn:self.field];
}

- (void)reloadData
{
	[[PuzzleSDK sharedInstance] getCommentsForPuzzle:self.puzzleID onCompletion:^(PuzzleAPIResponse response, NSArray *comments) {
		if (response == PuzzleOperationSuccessful)
		{
			if ([comments count] == 0)
			{
				[[[[UIAlertView alloc] initWithTitle:@"No Comments" message:@"There are no comments for the tactic yet. Be the first!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
			} else {
				self.messages = comments;
				[self.tbl reloadData];
				NSUInteger index = [messages count] - 1;
				[tbl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
			}
		}
		else
		{
			[PuzzleErrorHandler presentErrorForResponse:response];
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

- (void)add {
	if(![field.text isEqualToString:@""])
	{
		UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		[spinner startAnimating];
		spinner.center = self.view.center;
		[self.view addSubview:spinner];
		
		[[PuzzleSDK sharedInstance] addComment:self.field.text toPuzzle:self.puzzleID onCompletion:^(PuzzleAPIResponse response, NSArray *comments) {
			if (response == PuzzleOperationSuccessful)
			{
				[self reloadData];
				field.text = @"";
			}
			else
			{
				[PuzzleErrorHandler presentErrorForResponse:response];
			}
			[spinner removeFromSuperview];
			[spinner stopAnimating];
		}];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];	
	toolbar.frame = CGRectMake(0, 392, 320, 44);
	tbl.frame = CGRectMake(0, 0, 320, 392);	
	[UIView commitAnimations];
	
	return YES;
}

- (void)keyboardWillShow:(NSNotification *)notif {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];	
	toolbar.frame = CGRectMake(0, 176, 320, 44);
	tbl.frame = CGRectMake(0, 0, 320, 176);	
	[UIView commitAnimations];
	
	if([messages count] > 0)
	{
		NSUInteger index = [messages count] - 1;
		[tbl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	UIImageView *balloonView;
	UILabel *label;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;		
		
		balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
		balloonView.tag = 1;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.tag = 2;
		label.numberOfLines = 0;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.font = [UIFont systemFontOfSize:14.0];
		
		UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
		message.tag = 0;
		[message addSubview:balloonView];
		[message addSubview:label];
		[cell.contentView addSubview:message];
		
		[balloonView release];
		[label release];
		[message release];
	}
	else
	{
		balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
		label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
	}
	
	PuzzleComment *comment = [self.messages objectAtIndex:indexPath.row];
	NSString *text = [NSString stringWithFormat:@"%@: %@", comment.poster, comment.message];
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
	
	UIImage *balloon;
	
	if([comment.posterID isEqual:[PuzzleCurrentUser currentUser].userID])
	{
		balloonView.frame = CGRectMake(320.0f - (size.width + 28.0f), 2.0f, size.width + 28.0f, size.height + 15.0f);
		balloon = [[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
		label.frame = CGRectMake(307.0f - (size.width + 5.0f), 8.0f, size.width + 5.0f, size.height);
	}
	else
	{
		balloonView.frame = CGRectMake(0.0, 2.0, size.width + 28, size.height + 15);
		balloon = [[UIImage imageNamed:@"grey.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
		label.frame = CGRectMake(16, 8, size.width + 5, size.height);
	}
	
	balloonView.image = balloon;
	label.text = text;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	PuzzleComment *comment = [messages objectAtIndex:indexPath.row];
	NSString *body = [NSString stringWithFormat:@"%@: %@", comment.poster, comment.message];
	CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:UILineBreakModeWordWrap];
	return size.height + 15;
}

#pragma mark -

- (void)viewDidUnload {
	self.tbl = nil;
	self.field = nil;
	self.toolbar = nil;
}

- (void)dealloc {
	[tbl release];
	[field release];
	[toolbar release];
	[messages release];
	
	[__puzzleID release];
	__puzzleID = nil;
	
    [super dealloc];
}


@end

