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


#define MOVE_DELAY 0.5
#define SOLUTION_MOVE_DELAY 1.5

#define YOUR_NEW_RATING @"Your new rating: "
#define PUZZLE_RATING @"Puzzle rating: "
#define LOADING_RATINGS @"Loading rating changes..."
#define GIVE_UP @"Give Up"
#define NEXT_TACTIC @"Next Tactic"
#define SHOW_SOLUTION @"Show Solution"
#define EXPLANATION @"Explanation"
#define VIEW_COMMENTS @"View Comments"

@interface PlayPuzzleViewController () <ChessBoardViewControllerDelegate, UIAlertViewDelegate> {
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
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;
@property (nonatomic, readwrite, retain) NSArray *solutionMoves;
@property (nonatomic, readwrite, assign) int currentMove;
@property (nonatomic, readwrite, assign) Color playerColor;
@property (nonatomic, readwrite, assign) BOOL tacticStarted;
@property (nonatomic, readwrite, assign) BOOL showingSolution;
@property (nonatomic, readwrite, assign) dispatch_queue_t dispatchQueue;
@property (nonatomic, readwrite, assign) BOOL rated;
@property (nonatomic, readwrite, retain) UIBarButtonItem *nextTacticButton;

@property (nonatomic, readwrite, retain) UILabel *bottomLabel;
@property (nonatomic, readwrite, retain) UIView *hiddenButtonsView;

- (void)setupPuzzle;
- (void)startTactic:(NSNumber *)moveComputerFirst;
- (double)moveDelay;
- (IBAction)showSolution:(UIButton *)sender;
- (void)newTactic:(UIBarButtonItem *)button;
- (IBAction)showAnalysisBoard:(id)sender;
- (void)modalViewCancelled;
- (IBAction)showExplanationPressed:(id)sender;
- (IBAction)showCommentPressed:(id)sender;

@end

@implementation PlayPuzzleViewController

@synthesize chessBoardViewController = __chessBoardViewController, solutionMoves = __solutionMoves, currentMove = __currentMove, playerColor = __playerColor, tacticStarted = __tacticStarted, dispatchQueue = __dispatchQueue, puzzleModel = __puzzleModel, showingSolution = __showingSolution, bottomLabel = __bottomLabel, nextTacticButton = __nextTacticButton, rated = __rated, setupData = __setupData, solutionData = __solutionData, hiddenButtonsView = __hiddenButtonsView;

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
	
	self.nextTacticButton = [[[UIBarButtonItem alloc] initWithTitle:@"Give Up" style:UIBarButtonItemStyleBordered target:self action:@selector(newTactic:)] autorelease];
	self.navigationItem.rightBarButtonItem = self.nextTacticButton;
	
	if (!(self.solutionData && self.setupData) && !self.puzzleModel) {
		[[PuzzleDownloader sharedInstance] downloadPuzzleWithCallback:^(PuzzleAPIResponse response, PuzzleModel * puzzle) {
			if (response == PuzzleOperationSuccessful) {
				self.puzzleModel = puzzle;
				[self setupPuzzle];
			} else {
				[PuzzleErrorHandler presentErrorForResponse:response];
			}
		}];
	} else { //already have what we need
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
		[[[[UIAlertView alloc] initWithTitle:@"Success" message:@"Well done. Correct solution." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NEXT_TACTIC, nil] autorelease] show];
	} else {
		[[[[UIAlertView alloc] initWithTitle:@"Incorrect" message:@"Sorry, that's not the correct solution." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:EXPLANATION, SHOW_SOLUTION, nil] autorelease] show];
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

#pragma mark - ChessVC Delegate

- (void)piece:(ChessPiece *)piece didMoveFromX:(int)x Y:(int)y pawnPromoted:(NSString *)aClass {
	if ((piece.color == self.playerColor && self.tacticStarted) || self.showingSolution) { //do computer move
		ChessMove *lastMove = [self.solutionMoves objectAtIndex:self.currentMove];
		if (!(x == lastMove.start.x && y == lastMove.start.y && piece.x == lastMove.finish.x && piece.y == lastMove.finish.y && (aClass == nil || [aClass isEqualToString:lastMove.promotionType]))) { //wrong move
			[self endTactic:0]; //loss
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
	navController.navigationBar.tintColor = [UIColor blackColor];
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(modalViewCancelled)] autorelease];
	vc.navigationItem.leftBarButtonItem = cancelButton;
	[self presentModalViewController:navController animated:YES];
	
}

- (IBAction)showExplanationPressed:(id)sender
{
	NSString *explanation = nil;
	if (self.puzzleModel) {
		explanation = [self.puzzleModel.solutionData objectForKey:TACTIC_EXPLANATION];
	} else {
		explanation = [self.solutionData objectForKey:TACTIC_EXPLANATION];
	}
	if (explanation == nil || [explanation isEqualToString:@""]) 
	{
		explanation = @"Sorry, but no explanation was offered for this tactic. You may find some answers in the comments.";
	}
	[[[[UIAlertView alloc] initWithTitle:@"Explanation" message:explanation delegate:self cancelButtonTitle:@"OK" otherButtonTitles:VIEW_COMMENTS, nil] autorelease] show];
}

- (void)modalViewCancelled {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)newTactic:(UIBarButtonItem *)button {
	if ([button.title isEqualToString:NEXT_TACTIC]) {
		PlayPuzzleViewController *newTacticVC = [[[PlayPuzzleViewController alloc] init] autorelease];
		UINavigationController *tempController = self.navigationController;
		[[self retain] autorelease]; //so that this vc doesn't get dealloced
		[self.navigationController popViewControllerAnimated:NO];
		[tempController pushViewController:newTacticVC animated:YES];
	} else if ([button.title isEqualToString:GIVE_UP]) {
		[self endTactic:0];
	}
}

- (IBAction)showCommentPressed:(id)sender 
{
	CommentsTableViewController *vc = [[[CommentsTableViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NEXT_TACTIC])
	{
		PlayPuzzleViewController *newTacticVC = [[[PlayPuzzleViewController alloc] init] autorelease];
		UINavigationController *tempController = self.navigationController;
		[[self retain] autorelease]; //so that this vc doesn't get dealloced
		[self.navigationController popViewControllerAnimated:NO];
		[tempController pushViewController:newTacticVC animated:YES];
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
}

@end
