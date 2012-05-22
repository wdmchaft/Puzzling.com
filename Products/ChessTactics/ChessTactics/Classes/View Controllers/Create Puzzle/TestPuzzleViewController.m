//
//  TestPuzzleViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/13/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "TestPuzzleViewController.h"
#import "PuzzleSDK.h"
#import "EnterExplanationViewController.h"
#import "TacticsDataConstants.h"


#define SUBMIT_TACTIC @"Enter a Name for the Tactic"
#define SUCCESS @"Success"
#define SUBMIT @"Submit"

@interface TestPuzzleViewController () <UIAlertViewDelegate, EnterExplanationViewControllerDelegate> {
	IBOutlet UIActivityIndicatorView *__activityView;
	NSString *__tacticExplanation;
}

@property (nonatomic, readonly, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, readwrite, retain) NSString *tacticExplanation;

- (void)submitTactic:(NSString *)name;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)explanationButtonPressed:(id)sender;

@end

@implementation TestPuzzleViewController

@synthesize activityView = __activityView, tacticExplanation = __tacticExplanation;

- (id)initWithSetup:(NSDictionary *)setupData solutionData:(NSDictionary *)solutionData {
	if (self = [super initWithRated:NO]) {
		self.setupData = setupData;
		self.solutionData = solutionData;
	}
	return self;
}

- (void)dealloc {
	[__activityView release];
	__activityView = nil;
	[__tacticExplanation release];
	__tacticExplanation = nil;
	
	[super dealloc];
}

- (IBAction)submitButtonPressed:(id)sender {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:SUBMIT_TACTIC message:@"Note: This will not be visible to users while they attempt the tactic." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:SUBMIT, nil] autorelease];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alert show];
}

- (void)submitTactic:(NSString *)name {
	self.activityView.hidden = NO;
	[self.view bringSubviewToFront:self.activityView];
	[self.activityView startAnimating];
	self.view.userInteractionEnabled = NO;	
	
	NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:self.solutionData];
	[temp setValue:self.tacticExplanation forKey:TACTIC_EXPLANATION];
	self.solutionData = temp;
	
	[[PuzzleSDK sharedInstance] createPuzzleWithType:@"tactic" name:name setupData:self.setupData solutionData:self.solutionData onCompletionBlock:^(PuzzleAPIResponse status, id data) {
		self.activityView.hidden = YES;
		[self.activityView stopAnimating];
		self.view.userInteractionEnabled = YES;
		if (status == PuzzleOperationSuccessful) {
			[[[[UIAlertView alloc] initWithTitle:SUCCESS message:@"The tactic was successfully created." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		} else {
			[PuzzleErrorHandler presentErrorForResponse:status];
		}
	}];
}

- (IBAction)explanationButtonPressed:(id)sender
{
	EnterExplanationViewController *vc = [[[EnterExplanationViewController alloc] init] autorelease];
	vc.delegate = self;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)endTactic:(double)score {
	[super endTactic:score];
	
	self.navigationItem.rightBarButtonItem = nil; //There is no next tactic so remove button
}

- (void)showAlertViewForSuccess
{
	[[[[UIAlertView alloc] initWithTitle:@"Success" message:@"Well done. Correct solution." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

#pragma mark - Delegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([alertView.title isEqualToString:SUBMIT_TACTIC]) {
		if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:SUBMIT]) {
			[self submitTactic:[alertView textFieldAtIndex:0].text];
		}
	} else if ([alertView.title isEqualToString:SUCCESS]) {
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

- (void)enterExplanationViewController:(EnterExplanationViewController *)vc didEnterExplanation:(NSString *)explanation {
	self.tacticExplanation = explanation;
}

@end
