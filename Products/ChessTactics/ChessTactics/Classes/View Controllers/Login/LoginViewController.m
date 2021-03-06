//
//  LoginViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/20/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PuzzleSDK.h"
#import "PuzzleErrorHandler.h"
#import "ConstantsForUI.h"
#import "PlayGuestPuzzleViewController.h"


@interface LoginViewController () <UITextFieldDelegate> {
	IBOutlet UITextField *__usernameTextField;
	IBOutlet UITextField *__passwordTextField;
}

@property (nonatomic, readonly, retain) UITextField *usernameTextField;
@property (nonatomic, readonly, retain) UITextField *passwordTextField;

- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation LoginViewController

@synthesize usernameTextField = __usernameTextField, passwordTextField = __passwordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title = @"Chess Tactics";
	self.view.backgroundColor = BACKGROUND_COLOR;
	
	self.usernameTextField.delegate = self;
	self.passwordTextField.delegate = self;
}

- (void)dealloc
{
	[__usernameTextField release];
	__usernameTextField = nil;
	[__passwordTextField release];
	__passwordTextField = nil;
	
	[super dealloc];
}

- (IBAction)registerButtonPressed:(id)sender
{
	RegisterViewController *vc = [[[RegisterViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginButtonPressed:(id)sender
{
	[[PuzzleSDK sharedInstance] loginUserWithUsername:self.usernameTextField.text password:self.passwordTextField.text onCompletion:^(PuzzleAPIResponse response, id data) {
		if (response == PuzzleOperationSuccessful)
		{
			[self dismissModalViewControllerAnimated:YES];
		}
		else
		{
			[PuzzleErrorHandler presentErrorForResponse:response];
		}
	}];
}

- (IBAction)playAsGuestPressed:(id)sender
{
	PlayGuestPuzzleViewController *vc = [[[PlayGuestPuzzleViewController alloc] init] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.usernameTextField)
	{
		[self.passwordTextField becomeFirstResponder];
	}
	else if (textField == self.passwordTextField)
	{
		[self loginButtonPressed:nil];
	}
	return YES;
}

@end
