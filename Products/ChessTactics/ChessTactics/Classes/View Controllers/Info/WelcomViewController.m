//
//  WelcomViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 6/8/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "WelcomViewController.h"
#import "ConstantsForUI.h"


@interface WelcomViewController ()

- (IBAction)cancel:(id)sender;

@end

@implementation WelcomViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"How this App Works";
	
	self.view.backgroundColor = BACKGROUND_COLOR;
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)] autorelease];
	self.navigationItem.leftBarButtonItem = cancelButton;
}

- (IBAction)cancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
