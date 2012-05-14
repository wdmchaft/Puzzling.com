//
//  TestPuzzleViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/13/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "TestPuzzleViewController.h"
#import "PuzzleSDK.h"


@interface TestPuzzleViewController () <UIAlertViewDelegate> {
	IBOutlet UIActivityIndicatorView *__activityView;
}

@property (nonatomic, readonly, retain) UIActivityIndicatorView *activityView;

- (IBAction)submitTactic:(id)sender;

@end

@implementation TestPuzzleViewController

@synthesize activityView = __activityView;

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
	
	[super dealloc];
}

- (IBAction)submitTactic:(id)sender {
	self.activityView.hidden = NO;
	[self.view bringSubviewToFront:self.activityView];
	[self.activityView startAnimating];
	self.view.userInteractionEnabled = NO;	
	
	[[PuzzleSDK sharedInstance] createPuzzleWithType:@"tactic" setupData:self.setupData solutionData:self.solutionData onCompletionBlock:^(PuzzleAPIResponse status, id data) {
		self.activityView.hidden = YES;
		[self.activityView stopAnimating];
		self.view.userInteractionEnabled = YES;
		if (status == PuzzleOperationSuccessful) {
			[[[[UIAlertView alloc] initWithTitle:@"Success" message:@"The tactic was successfully created." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		} else {
			NSLog(@"aww crap");
		}
	}];
}

- (void)endTactic:(double)score {
	[super endTactic:score];
	
	self.navigationItem.rightBarButtonItem = nil; //There is no next tactic so remove button
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
