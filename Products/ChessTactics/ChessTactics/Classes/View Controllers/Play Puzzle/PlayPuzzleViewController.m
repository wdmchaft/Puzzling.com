//
//  PlayPuzzleViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 4/30/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PlayPuzzleViewController.h"
#import "ChessBoardViewController.h"
#import "PuzzleDownloader.h"
#import "TacticsDataConstants.h"
#import "TacticsDataConstants.h"
#import "Coordinate.h"
#import "ChessMove.h"
#import "TakePuzzleResults.h"
#import "AnalysisBoardViewController.h"
#import "CommentsTableViewController.h"
#import "PuzzleErrorHandler.h"
#import "ConstantsForUI.h"
#import "PuzzleCurrentUser.h"


#define MOVE_DELAY 0.5
#define SOLUTION_MOVE_DELAY 1.5

#define YOUR_NEW_RATING @"Your new rating: "
#define PUZZLE_RATING @"Puzzle rating: "
#define LOADING_RATINGS @"Loading rating changes..."
#define GIVE_UP @"Give Up"
#define NEXT_TACTIC @"Next Tactic"
#define EXPLANATION @"Explanation"
#define VIEW_COMMENTS @"View Comments"
#define LIKE @"Like"
#define DISLIKE @"Dislike"
#define FLAG_FOR_REMOVAL @"Flag for Removal"
#define SET_LIKED_PUZZLES @"set_liked_puzzles"

@interface PlayPuzzleViewController () <ChessBoardViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
	IBOutlet UILabel *__bottomLabel;
	IBOutlet UIView *__hiddenButtonsView;
	
	ChessBoardViewController *__chessBoardViewController;
	NSArray *__solutionMoves;
	int __currentMove;
	Color __playerColor;
	BOOL __tacticStarted;
	dispatch_queue_t __dispatchQueue;
	PuzzleModel *__puzzleModel;
	BOOL __showingSolution;
	UIBarButtonItem *__nextTacticButton;
	BOOL __rated;
	PuzzleID *__puzzleID;
	
	UIAlertView *__alertView;
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;
@property (nonatomic, readwrite, retain) NSArray *solutionMoves;
@property (nonatomic, readwrite, assign) int currentMove;
@property (nonatomic, readwrite, assign) Color playerColor;
@property (nonatomic, readwrite, assign) BOOL tacticStarted;
@property (nonatomic, readwrite, assign) BOOL showingSolution;
@property (nonatomic, readwrite, assign) dispatch_queue_t dispatchQueue;
@property (nonatomic, readwrite, retain) UIBarButtonItem *nextTacticButton;

@property (nonatomic, readwrite, retain) UIView *hiddenButtonsView;
@property (nonatomic, readwrite, retain) UIAlertView *alertView;

- (void)setupPuzzle;
- (void)startTactic:(NSNumber *)moveComputerFirst;
- (double)moveDelay;
- (IBAction)showSolution:(UIButton *)sender;
- (void)newTactic:(UIBarButtonItem *)button;
- (IBAction)showAnalysisBoard:(id)sender;
- (void)modalViewCancelled;
- (IBAction)showExplanationPressed:(id)sender;
- (IBAction)showCommentPressed:(id)sender;
- (IBAction)menuPressed:(id)sender;
- (void)showAlertViewForSuccess;

@end

@implementation PlayPuzzleViewController

@synthesize chessBoardViewController = __chessBoardViewController, solutionMoves = __solutionMoves, currentMove = __currentMove, playerColor = __playerColor, tacticStarted = __tacticStarted, dispatchQueue = __dispatchQueue, puzzleModel = __puzzleModel, showingSolution = __showingSolution, bottomLabel = __bottomLabel, nextTacticButton = __nextTacticButton, rated = __rated, setupData = __setupData, solutionData = __solutionData, hiddenButtonsView = __hiddenButtonsView, puzzleID = __puzzleID, alertView = __alertView;

#pragma mark - View Life Cycle

- (id)initWithRated:(BOOL)rated {
	if (self = [super init]) {
		self.rated = rated;
	}
	return self;
}

- (id)init {
	self = [self initWithRated:YES]; //default
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tacticStarted = NO;
	self.showingSolution = NO;
	self.dispatchQueue = dispatch_queue_create("playTacticsQueue", NULL);
	self.hiddenButtonsView.hidden = YES;
	
	self.title = @"Tactic";
	self.view.backgroundColor = BACKGROUND_COLOR;
	self.hiddenButtonsView.backgroundColor = [UIColor clearColor];
	
	self.nextTacticButton = [[[UIBarButtonItem alloc] initWithTitle:@"Give Up" style:UIBarButtonItemStyleBordered target:self action:@selector(newTactic:)] autorelease];
	self.navigationItem.rightBarButtonItem = self.nextTacticButton;
	
	if (!(self.solutionData && self.setupData) && !self.puzzleModel && !self.puzzleID)
	{
		[[PuzzleDownloader sharedInstance] downloadPuzzleWithCallback:^(PuzzleAPIResponse response, PuzzleModel * puzzle) {
			if (response == PuzzleOperationSuccessful) {
				self.puzzleModel = puzzle;
				[self setupPuzzle];
			} else {
				[PuzzleErrorHandler presentErrorForResponse:response];
			}
		}];
	} 
	else if (self.puzzleID) 
	{
		[[PuzzleSDK sharedInstance] getPuzzle:self.puzzleID onCompletion:^(PuzzleAPIResponse response, PuzzleModel * puzzle)
		 {
			 if (response == PuzzleOperationSuccessful) {
				 self.puzzleModel = puzzle;
				 [self setupPuzzle];
			 } else {
				 [PuzzleErrorHandler presentErrorForResponse:response];
			 }
		 }];
	} 
	else
	{ //already have what we need
		[self setupPuzzle];
	}
}

- (void)dealloc {
	[__chessBoardViewController release];
	__chessBoardViewController = nil;
	[__solutionMoves release];
	__solutionMoves = nil;
	[__puzzleModel release];
	__puzzleModel = nil;
	[__bottomLabel release];
	__bottomLabel = nil;
	[__nextTacticButton release];
	__nextTacticButton = nil;
	[__setupData release];
	__setupData = nil;
	[__solutionData release];
	__solutionData = nil;
	[__hiddenButtonsView release];
	__hiddenButtonsView = nil;
	__alertView.delegate = nil;
	[__alertView release];
	__alertView = nil;
	
	if (__dispatchQueue != nil) {
		dispatch_release(__dispatchQueue);
		__dispatchQueue = nil;
	}
	
	[super dealloc];
}

#pragma mark - Private Methods

- (void)setupPuzzle {
	NSDictionary *setupData;
	if (self.setupData == nil) {
		setupData = self.puzzleModel.setupData;
	} else {
		setupData = self.setupData;
	}
	
	if ([[setupData objectForKey:PLAYER_COLOR] isEqualToString:WHITE]) {
		self.playerColor = kWhite;
	} else if ([[setupData objectForKey:PLAYER_COLOR] isEqualToString:BLACK]) {
		self.playerColor = kBlack;
	}
	
	self.chessBoardViewController = [[[ChessBoardViewController alloc] initWithColor:self.playerColor] autorelease];
	self.chessBoardViewController.inEditingMode = NO;
	self.chessBoardViewController.delegate = self;
	self.chessBoardViewController.fullBoard = NO;
	[self.view addSubview:self.chessBoardViewController.view];
	
	NSArray *piecesSetup = [setupData objectForKey:PIECES_SETUP];
	[self.chessBoardViewController setupPieces:piecesSetup];
	[self.chessBoardViewController resetAllPiecesToHaveNotMoved];
	
	NSArray *moves;
	if (self.solutionData == nil) {
		moves = [self.puzzleModel.solutionData objectForKey:MOVES];
	} else {
		moves = [self.solutionData objectForKey:MOVES];
	}
	
	NSMutableArray *tempSolutionMoves = [NSMutableArray arrayWithCapacity:[moves count]];
	for (NSDictionary *move in moves) {
		ChessMove *chessMove = [[[ChessMove alloc] init] autorelease];
		chessMove.start = [[[Coordinate alloc] initWithX:[[move objectForKey:START_X] intValue] Y:[[move objectForKey:START_Y] intValue]] autorelease];
		chessMove.finish = [[[Coordinate alloc] initWithX:[[move objectForKey:FINISH_X] intValue] Y:[[move objectForKey:FINISH_Y] intValue]] autorelease];
		chessMove.promotionType = [move objectForKey:PROMOTION_TYPE];
		[tempSolutionMoves addObject:chessMove];
	}
	self.solutionMoves = tempSolutionMoves;
	self.currentMove = 0;
	
	self.chessBoardViewController.interactionAllowed = NO;
	
	dispatch_async(self.dispatchQueue, ^(void) {
		usleep(1000000*[self moveDelay]);
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			[self startTactic:[setupData objectForKey:COMPUTER_MOVE_FIRST]];
		});
	});
}

- (void)startTactic:(NSNumber *)moveComputerFirst {
	self.tacticStarted = YES;
	if ([moveComputerFirst boolValue] && !self.showingSolution)
	{
		[self setHelpMessageForLastPlayerColor:self.playerColor];
	}
	else if (!self.showingSolution)
	{
		[self setHelpMessageForLastPlayerColor:self.playerColor==kWhite?kBlack:kWhite];
	}
	if ([moveComputerFirst boolValue]) {
		ChessMove *move = [self.solutionMoves objectAtIndex:self.currentMove];
		[self.chessBoardViewController movePieceFromX:move.start.x Y:move.start.y toX:move.finish.x Y:move.finish.y promotion:move.promotionType];
		self.currentMove++;
	}
	if (!self.showingSolution) {
		self.chessBoardViewController.interactionAllowed = YES;
		self.navigationItem.hidesBackButton = YES;
	}
}

- (double)moveDelay {
	if (self.showingSolution) {
		return SOLUTION_MOVE_DELAY;
	} else {
		return MOVE_DELAY;
	}
}

- (void)showPuzzleFailMessage:(double)score
{
	int scoreInt = score * 100 + .5;
	self.alertView = [[[UIAlertView alloc] initWithTitle:@"Incorrect" message:[NSString stringWithFormat:@"Sorry, that's not the correct solution.\nScore: %d%%", scoreInt] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:EXPLANATION, SHOW_SOLUTION, nil] autorelease];
	[self.alertView show];
}

- (void)endTactic:(double)score {
	self.chessBoardViewController.view.userInteractionEnabled = NO;
	self.navigationItem.hidesBackButton = NO;
	self.hiddenButtonsView.hidden = NO;
	
	if (self.showingSolution)
	{
		self.showingSolution = NO;
		return;
	}
	
	self.nextTacticButton.title = NEXT_TACTIC;
	
	if (score == 1) {
		[self showAlertViewForSuccess];
	} else {
		[self showPuzzleFailMessage:score];
	}
	
	self.bottomLabel.text = LOADING_RATINGS;
	if (self.puzzleModel.puzzleID != nil) {
		[[PuzzleSDK sharedInstance] takePuzzle:self.puzzleModel.puzzleID score:score rated:self.rated onCompletion:^(PuzzleAPIResponse response, TakePuzzleResults *results) {
			if (response == PuzzleOperationSuccessful) {
				self.bottomLabel.text = [NSString stringWithFormat:@"%@%d(%@%d)\n%@%d", YOUR_NEW_RATING, results.newUserRating, results.userRatingChange>=0?@"+":@"", results.userRatingChange, PUZZLE_RATING, results.newPuzzleRating-results.puzzleRatingChange];
			} else {
				self.bottomLabel.text = @"There was a problem getting rating changes. Sorry.";
			}
		}];
	}
}


- (void)showAlertViewForSuccess
{
	self.alertView = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Well done. Correct solution." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NEXT_TACTIC, nil] autorelease];
	[self.alertView show];
}

- (void)setHelpMessageForLastPlayerColor:(Color)color {
	NSString *helpMessage;
	if (color == self.playerColor)
	{
		helpMessage = [NSString stringWithFormat:@"Waiting for computer move... (%@)", color==kWhite?@"Black":@"White"];
	}
	else
	{
		helpMessage = [NSString stringWithFormat:@"Your move. (%@)", color==kWhite?@"Black":@"White"];
	}
	self.bottomLabel.text = helpMessage;
}

#pragma mark - ChessVC Delegate

- (void)piece:(ChessPiece *)piece didMoveFromX:(int)x Y:(int)y pawnPromoted:(NSString *)aClass {
	if (!self.showingSolution && self.tacticStarted)
	{
		[self setHelpMessageForLastPlayerColor:piece.color];
	}
	if ((piece.color == self.playerColor && self.tacticStarted) || self.showingSolution) { //do computer move
		ChessMove *lastMove = [self.solutionMoves objectAtIndex:self.currentMove];
		if (!(x == lastMove.start.x && y == lastMove.start.y && piece.x == lastMove.finish.x && piece.y == lastMove.finish.y && (aClass == nil || [aClass isEqualToString:lastMove.promotionType]))) { //wrong move
			int numberOfMoves = [self.solutionMoves count] / 2;
			double score = (self.currentMove/2) / (double)numberOfMoves;
			[self endTactic:score]; //loss
			return;
		}
		if (!self.showingSolution) {
			self.currentMove++;
		}
		if (self.currentMove >= [self.solutionMoves count]) {
			[self endTactic:1];
		} else {
			self.chessBoardViewController.view.userInteractionEnabled = NO;
			dispatch_async(self.dispatchQueue, ^(void) {
				usleep(1000000*[self moveDelay]);
				dispatch_async(dispatch_get_main_queue(), ^(void) {
					if (self.currentMove >= [self.solutionMoves count]) {
						[self endTactic:1];
						return;
					}
					ChessMove *move = [self.solutionMoves objectAtIndex:self.currentMove];
					[self.chessBoardViewController movePieceFromX:move.start.x Y:move.start.y toX:move.finish.x Y:move.finish.y promotion:move.promotionType];
					self.currentMove++;
					if (!self.showingSolution) {
						self.chessBoardViewController.view.userInteractionEnabled = YES;
					}
				});
			});
		}
	}
}

#pragma mark - Buttons

- (IBAction)showSolution:(UIButton *)sender {
	if (self.showingSolution) {
		return; //already doing it
	}
	self.tacticStarted = NO;
	self.showingSolution = NO;
	[self setupPuzzle];
	self.showingSolution = YES;
	self.chessBoardViewController.view.userInteractionEnabled = NO;
}

- (IBAction)showAnalysisBoard:(id)sender {
	AnalysisBoardViewController *vc = [[[AnalysisBoardViewController alloc] init] autorelease];
	if (self.puzzleModel) {
		vc.setupData = self.puzzleModel.setupData;
		vc.computerMoveFirst = [[self.puzzleModel.setupData objectForKey:COMPUTER_MOVE_FIRST] boolValue];
	} else {
		vc.setupData = self.setupData;
		vc.computerMoveFirst = [[self.setupData objectForKey:COMPUTER_MOVE_FIRST] boolValue];
	}
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
	navController.navigationBar.tintColor = [UIColor brownColor];
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(modalViewCancelled)] autorelease];
	UIImage *navBarImage = [UIImage imageNamed: @"NavBar-Wood"];
	[navController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
	vc.navigationItem.leftBarButtonItem = cancelButton;
	[self presentModalViewController:navController animated:YES];
	
}

- (IBAction)showExplanationPressed:(id)sender
{
	NSString *explanation = nil;
	if (self.puzzleModel)
	{
		explanation = [self.puzzleModel.solutionData objectForKey:TACTIC_EXPLANATION];
	} 
	else
	{
		explanation = [self.solutionData objectForKey:TACTIC_EXPLANATION];
	}
	if (explanation == nil || [explanation isEqualToString:@""]) 
	{
		explanation = @"Sorry, but no explanation was offered for this tactic. You may find some answers in the comments.";
	}
	self.alertView = [[[UIAlertView alloc] initWithTitle:@"Explanation" message:explanation delegate:self cancelButtonTitle:@"OK" otherButtonTitles:VIEW_COMMENTS, nil] autorelease];
	[self.alertView show];
}

- (void)modalViewCancelled {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)presentNextTactic
{
	PlayPuzzleViewController *newTacticVC = [[[PlayPuzzleViewController alloc] init] autorelease];
	UINavigationController *tempController = self.navigationController;
	[[self retain] autorelease]; //so that this vc doesn't get dealloced
	[self.navigationController popViewControllerAnimated:NO];
	[tempController pushViewController:newTacticVC animated:YES];
}

- (void)newTactic:(UIBarButtonItem *)button {
	if ([button.title isEqualToString:NEXT_TACTIC]) {
		[self presentNextTactic];
	} else if ([button.title isEqualToString:GIVE_UP]) {
		[self endTactic:0];
	}
}

- (IBAction)showCommentPressed:(id)sender 
{
	CommentsTableViewController *vc = [[[CommentsTableViewController alloc] init] autorelease];
	vc.puzzleID = self.puzzleModel.puzzleID;
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)menuPressed:(id)sender
{
	UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:LIKE, DISLIKE, FLAG_FOR_REMOVAL, nil] autorelease];
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:LIKE])
	{
		PuzzleID *puzzleID = nil;
		if (self.puzzleID)
		{
			puzzleID = self.puzzleID;
		}
		else
		{
			puzzleID = self.puzzleModel.puzzleID;
		}
		
		NSMutableSet *likedPuzzles = [[NSUserDefaults standardUserDefaults] objectForKey:SET_LIKED_PUZZLES];
		if (likedPuzzles == nil)
		{
			[[NSUserDefaults standardUserDefaults] setObject:[NSMutableSet set] forKey:SET_LIKED_PUZZLES];
			likedPuzzles = [[NSUserDefaults standardUserDefaults] objectForKey:SET_LIKED_PUZZLES];
		}
		if ([likedPuzzles containsObject:puzzleID])
		{
			[[[[UIAlertView alloc] initWithTitle:@"Can't Like" message:@"You've already liked/disliked this puzzle before." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}
		else if (!self.puzzleModel.creatorID)
		{
			self.alertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Looks like this tactic hasn't been uploaded to the server yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[self.alertView show];
		}/*
		else if ([self.puzzleModel.creatorID isEqualToString:[PuzzleCurrentUser currentUser].userID])
		{
			self.alertView = [[[UIAlertView alloc] initWithTitle:@"This is your tactic" message:@"You can't like your own tactic." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[self.alertView show];
		} */
		else
		{
			[likedPuzzles addObject:puzzleID];
			[[NSUserDefaults standardUserDefaults] setObject:likedPuzzles forKey:SET_LIKED_PUZZLES];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			[[PuzzleSDK sharedInstance] likePuzzle:puzzleID onCompletion:^(PuzzleAPIResponse response, id data) {
				if (response == PuzzleOperationSuccessful) {
					[[[[UIAlertView alloc] initWithTitle:@"Success" message:@"Puzzle was liked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
				} else {
					[PuzzleErrorHandler presentErrorForResponse:response];
				}
			}];
		}
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:DISLIKE])
	{
		PuzzleID *puzzleID = nil;
		if (self.puzzleID)
		{
			puzzleID = self.puzzleID;
		}
		else
		{
			puzzleID = self.puzzleModel.puzzleID;
		}
		if (!self.puzzleModel.creatorID)
		{
			self.alertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Looks like this tactic hasn't been uploaded to the server yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[self.alertView show];
		}
		else if ([self.puzzleModel.creatorID isEqualToString:[PuzzleCurrentUser currentUser].userID])
		{
			self.alertView = [[[UIAlertView alloc] initWithTitle:@"This is your tactic" message:@"You can't dislike your own tactic." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[self.alertView show];
		} 
		else
		{
			[[PuzzleSDK sharedInstance] dislikePuzzle:puzzleID onCompletion:^(PuzzleAPIResponse response, id data) {
				if (response == PuzzleOperationSuccessful) {
					[[[[UIAlertView alloc] initWithTitle:@"Success" message:@"Puzzle was disliked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
				} else {
					[PuzzleErrorHandler presentErrorForResponse:response];
				}
			}];
		}
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:FLAG_FOR_REMOVAL])
	{
		self.alertView = [[[UIAlertView alloc] initWithTitle:FLAG_FOR_REMOVAL message:@"You should only flag a puzzle for removal if it violates a rule of chess or has problem which makes it unsolvable (more than one potential best move). Make sure you check the comments and explanation before you submit." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:FLAG_FOR_REMOVAL, nil] autorelease];
		[self.alertView show];
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NEXT_TACTIC])
	{
		[self presentNextTactic];
	}
	else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:SHOW_SOLUTION]) 
	{
		[self showSolution:nil];
	}
	else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:EXPLANATION]) 
	{
		[self showExplanationPressed:nil];
		[self showSolution:nil];
	}
	else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:VIEW_COMMENTS]) 
	{
		[self showCommentPressed:nil];
	}
	else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:FLAG_FOR_REMOVAL]) 
	{
		if (self.puzzleModel)
		{
			[[PuzzleSDK sharedInstance] flagPuzzleForRemoval:self.puzzleModel.puzzleID onCompletion:^(PuzzleAPIResponse response, id data)
			 {
				 if (response == PuzzleOperationSuccessful)
				 {
					 [[[[UIAlertView alloc] initWithTitle:@"Success" message:@"Puzzle flagged for removal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
				 }
				 else
				 {
					 [PuzzleErrorHandler presentErrorForResponse:response];
				 }
			 }];
		}
		else
		{
			[[[[UIAlertView alloc] initWithTitle:@"Unable to flag this puzzle" message:@"Unable to flag this puzzle for removal. Perhaps it hasn't been uploaded to the server yet?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}
	}
}

@end
