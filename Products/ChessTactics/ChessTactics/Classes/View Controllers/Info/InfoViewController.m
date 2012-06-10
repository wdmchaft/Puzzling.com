//
//  InfoViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/25/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "InfoViewController.h"
#import "MessageUI/MessageUI.h"
#import "ConstantsForUI.h"


@interface InfoViewController() <MFMailComposeViewControllerDelegate>
{
	IBOutlet UIButton *__downloadButton1;
	IBOutlet UIButton *__downloadButton2;
	IBOutlet UIButton *__downloadButton3;
	IBOutlet UIButton *__emailButton;
}

@property (nonatomic, readonly, retain) UIButton *downloadButton1;
@property (nonatomic, readonly, retain) UIButton *downloadButton2;
@property (nonatomic, readonly, retain) UIButton *downloadButton3;
@property (nonatomic, readonly, retain) UIButton *emailButton;

- (void)close;

@end

@implementation InfoViewController

@synthesize downloadButton1 = __downloadButton1, downloadButton2 = __downloadButton2, downloadButton3 = __downloadButton3, emailButton = __emailButton;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"Info";
	
	self.view.backgroundColor = BACKGROUND_COLOR;
//	[self.downloadButton1 setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.downloadButton2 setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.downloadButton3 setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
//	[self.emailButton setBackgroundImage:PLAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(close)] autorelease];
	self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)dealloc
{
	[__downloadButton1 release];
	__downloadButton1 = nil;
	[__downloadButton2 release];
	__downloadButton2 = nil;
	[__downloadButton3 release];
	__downloadButton3 = nil;
	[__emailButton release];
	__emailButton = nil;
	
	[super dealloc];
}

-(IBAction) sendEmailPressed {
	
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		[picker setToRecipients:[NSArray arrayWithObject:@"chesstacticsapp@gmail.com"]];
		
		UIImage *navBarImage = [UIImage imageNamed: @"NavBar-Wood"];
		[picker.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
		picker.navigationBar.tintColor = [UIColor brownColor];
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	} else {
		UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Unable to send email." message:@"For some reason, your iPhone can't send email. Perhaps you haven't set it up yet?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[alert show];
			[alert release];	
		}
		break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)downloadOnTiltPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.itunes.com/apps/ontilt"]];
}

- (IBAction)downloadFriskyPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.itunes.com/apps/friskychess"]];
}

- (IBAction)downloadRiskPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.itunes.com/apps/riskdicesimulator"]];
}

- (void)close
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
