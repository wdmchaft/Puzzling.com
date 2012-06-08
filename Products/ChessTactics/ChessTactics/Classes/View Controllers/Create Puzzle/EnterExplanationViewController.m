//
//  EnterExplanationViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/18/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "EnterExplanationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ConstantsForUI.h"


@interface EnterExplanationViewController () {
	IBOutlet UITextView *__textView;
	id<EnterExplanationViewControllerDelegate> __delegate;
	IBOutlet UIButton *__submitButton;
}

@property (nonatomic, readonly, retain) UITextView *textView;
@property (nonatomic, readonly, retain) UIButton *submitButton;

- (IBAction)submitPressed:(id)sender;

@end

@implementation EnterExplanationViewController

@synthesize submitButton = __submitButton;
@synthesize textView = __textView;
@synthesize delegate = __delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title = @"Enter Explanation";
	self.view.backgroundColor = BACKGROUND_COLOR;
	
//	[self.submitButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
	
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
	[__submitButton release];
	__submitButton = nil;
	
	[super dealloc];
}

@end
