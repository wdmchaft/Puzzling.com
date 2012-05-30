//
//  TacticGuidelinesViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/25/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "TacticGuidelinesViewController.h"
#import "ConstantsForUI.h"


@interface TacticGuidelinesViewController () {
	IBOutlet UIView *__contentView;
	IBOutlet UIButton *__stockfishButton;
}

@property (nonatomic, readonly, retain) UIView *contentView;
@property (nonatomic, readonly, retain) UIButton *stockfishButton;

- (IBAction)downloadStockfishPressed:(id)sender;

@end

@implementation TacticGuidelinesViewController

@synthesize contentView = __contentView, stockfishButton = __stockfishButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Guidelines";
    
//	[self.stockfishButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
	self.view.backgroundColor = BACKGROUND_COLOR;
	UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:self.view.frame] autorelease];
	scrollView.contentSize = self.contentView.frame.size;
	[scrollView addSubview:self.contentView];
	self.contentView.backgroundColor = BACKGROUND_COLOR;
	[self.view addSubview:scrollView];
}

- (void)dealloc
{
	[__contentView release];
	__contentView = nil;
	[__stockfishButton release];
	__stockfishButton = nil;
	
	[super dealloc];
}

- (IBAction)downloadStockfishPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.itunes.com/apps/stockfishchess"]];
}

@end
