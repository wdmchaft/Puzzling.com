//
//  EnterExplanationViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/18/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "EnterExplanationViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface EnterExplanationViewController () {
	IBOutlet UITextView *__textView;
	id<EnterExplanationViewControllerDelegate> __delegate;
}

@property (nonatomic, readonly, retain) UITextView *textView;

- (IBAction)submitPressed:(id)sender;

@end

@implementation EnterExplanationViewController

@synthesize textView = __textView;
@synthesize delegate = __delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title = @"Enter Explanation";
	
	self.textView.editable = YES;
	[self.textView becomeFirstResponder];
	
	[[self.textView layer] setBorderColor:[[UIColor blackColor] CGColor]];
	[[self.textView layer] setBorderWidth:1];
	[[self.textView layer] setCornerRadius:5];
	[self.textView setClipsToBounds: YES];
}

- (IBAction)submitPressed:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(enterExplanationViewController:didEnterExplanation:)])
	{
		[self.delegate enterExplanationViewController:self didEnterExplanation:self.textView.text];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
	[__textView release];
	__textView = nil;
	
	[super dealloc];
}

@end
