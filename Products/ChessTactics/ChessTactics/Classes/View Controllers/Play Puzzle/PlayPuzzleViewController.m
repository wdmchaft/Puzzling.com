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


#define MOVE_DELAY 0.5
#define SOLUTION_MOVE_DELAY 1.5

#define YOUR_NEW_RATING @"Your new rating: "
#define PUZZLE_RATING @"Puzzle rating: "
#define LOADING_RATINGS @"Loading rating changes..."
#define GIVE_UP @"Give Up"
#define NEXT_TACTIC @"Next Tactic"

@interface PlayPuzzleViewController () <ChessBoardViewControllerDelegate> {
	ChessBoardViewController *__chessBoardViewController;
	NSArray *__solutionMoves;
	int __currentMove;
	Color __playerColor;
	BOOL __tacticStarted;
	dispatch_queue_t __dispatchQueue;
	PuzzleModel *__puzzleModel;
	BOOL __showingSolution;
	IBOutlet UILabel *__bottomLabel;
	UIBarButtonItem *__nextTacticButton;
}

@property (nonatomic, readwrite, retain) ChessBoardViewController *chessBoardViewController;
@property (nonatomic, readwrite, retain) NSArray *solutionMoves;
@property (nonatomic, readwrite, retain) PuzzleModel *puzzleModel;
@property (nonatomic, readwrite, retain) UILabel *bottomLabel;
@property (nonatomic, readwrite, retain) UIBarButtonItem *nextTacticButton;
@property (nonatomic, readwrite, assign) int currentMove;
@property (nonatomic, readwrite, assign) Color playerColor;
@property (nonatomic, readwrite, assign) BOOL tacticStarted;
@property (nonatomic, readwrite, assign) BOOL showingSolution;
@property (nonatomic, readwrite, assign) dispatch_queue_t dispatchQueue;

- (void)setupPuzzle;
- (void)startTactic:(NSNumber *)moveComputerFirst;
- (double)moveDelay;
- (IBAction)showSolution:(UIButton *)sender;
- (void)newTactic:(UIBarButtonItem *)button;
- (void)endTactic:(double)score;
- (IBAction)showAnalysisBoard:(id)sender;
- (void)modalViewCancelled;

@end

@implementation PlayPuzzleViewController

@synthesize chessBoardViewController = __chessBoardViewController, solutionMoves = __solutionMoves, currentMove = __currentMove, playerColor = __playerColor, tacticStarted = __tacticStarted, dispatchQueue = __dispatchQueue, puzzleModel = __puzzleModel, showingSolution = __showingSolution, bottomLabel = __bottomLabel, nextTacticButton = __nextTacticButton;

#pragma mark - View Lify Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tacticStarted = NO;
	self.showingSolution = NO;
	self.dispatchQueue = dispatch_queue_create("playTacticsQueue", NULL);
	
	self.title = @"Tactic";
	
	self.nextTacticButton = [[[UIBarButtonItem alloc] initWithTitle:@"Give Up" style:UIBarButtonItemStyleBordered target:self action:@selector(newTactic:)] autorelease];
	self.navigationItem.rightBarButtonItem = self.nextTacticButton;
	
	[[PuzzleDownloader sharedInstance] downloadPuzzleWithCallback:^(PuzzleModel * puzzle) {
		self.puzzleModel = puzzle;
		[self setupPuzzle];
	}];
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
	if (__dispatchQueue != nil) {
		dispatch_release(__dispatchQueue);
		__dispatchQueue = nil;
	}
	
	[super dealloc];
}

#pragma mark - Private Methods

- (void)setupPuzzle {
	NSDictionary *setupData = self.puzzleModel.setupData;
	
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
	
	NSArray *moves = [self.puzzleModel.solutionData objectForKey:MOVES];
	NSMutableArray *tempSolutionMoves = [NSMutableArray arrayWithCapacity:[moves count]];
	for (NSDictionary *move in moves) {
		ChessMove *chessMove = [[[ChessMove alloc] init] autorelease];
		chessMove.start = [[[Coordinate alloc] initWithX:[[move objectForKey:START_X] intValue] Y:[[move objectForKey:START_Y] intValue]] autorelease];
		chessMove.finish = [[[Coordinate alloc] initWithX:[[move objectForKey:FINISH_X] intValue] Y:[[move objectForKey:FINISH_Y] intValue]] autorelease];
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
		[self.chessBoardViewController movePieceFromX:move.start.x Y:move.start.y toX:move.finish.x Y:move.finish.y];
		self.currentMove++;
	}
	self.chessBoardViewController.interactionAllowed = YES;
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
	
	self.nextTacticButton.title = NEXT_TACTIC;
	
	NSString *title = @"";
	if (score == 1) {
		title = @"Win";
	} else {
		title = @"Fail";
	}
	[[[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
	
	self.bottomLabel.text = LOADING_RATINGS;
	[[PuzzleSDK sharedInstance] takePuzzle:self.puzzleModel.puzzleID score:score onCompletion:^(PuzzleAPIResponse response, TakePuzzleResults *results) {
		if (response == PuzzleOperationSuccessful) {
			self.bottomLabel.text = [NSString stringWithFormat:@"%@%d(%@%d)\n%@%d", YOUR_NEW_RATING, results.newUserRating, results.userRatingChange>=0?@"+":@"", results.userRatingChange, PUZZLE_RATING, results.newPuzzleRating];
		} else {
			self.bottomLabel.text = @"There was a problem getting rating changes. Sorry.";
		}
	}];
}

#pragma mark - ChessVC Delegate

- (void)piece:(ChessPiece *)piece didMoveFromX:(int)x Y:(int)y {
	if ((piece.color == self.playerColor && self.tacticStarted) || self.showingSolution) { //do computer move
		ChessMove *lastMove = [self.solutionMoves objectAtIndex:self.currentMove];
		if (!self.showingSolution && !(x == lastMove.start.x && y == lastMove.start.y && piece.x == lastMove.finish.x && piece.y == lastMove.finish.y)) { //wrong move
			[self endTactic:0]; //loss
			return;
		}
		if (!self.showingSolution) {
			self.currentMove++;
		}
		if (self.currentMove >= [self.solutionMoves count]) {
			if (!self.showingSolution) {
				[self endTactic:1];
			} else {
				self.showingSolution = NO;
			}
		} else {
			self.chessBoardViewController.view.userInteractionEnabled = NO;
			dispatch_async(self.dispatchQueue, ^(void) {
				usleep(1000000*[self moveDelay]);
				dispatch_async(dispatch_get_main_queue(), ^(void) {
					if (self.currentMove >= [self.solutionMoves count]) {
						return;
					}
					ChessMove *move = [self.solutionMoves objectAtIndex:self.currentMove];
					[self.chessBoardViewController movePieceFromX:move.start.x Y:move.start.y toX:move.finish.x Y:move.finish.y];
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
	vc.puzzleModel = self.puzzleModel;
	vc.computerMoveFirst = [[self.puzzleModel.setupData objectForKey:COMPUTER_MOVE_FIRST] boolValue];
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
	navController.navigationBar.tintColor = [UIColor blackColor];
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(modalViewCancelled)] autorelease];
	vc.navigationItem.leftBarButtonItem = cancelButton;
	[self presentModalViewController:navController animated:YES];
	
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

@end
