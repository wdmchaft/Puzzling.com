//
//  RegisterViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/20/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "RegisterViewController.h"
#import "PuzzleSDK.h"
#import "PuzzleErrorHandler.h"
#import "ConstantsForUI.h"


@interface RegisterViewController () 
{
	IBOutlet UITextField *__usernameTextField;
	IBOutlet UITextField *__passwordTextField;
	IBOutlet UITextField *__confirmPasswordTextField;
	IBOutlet UITextField *__emailTextField;
}

@property (nonatomic, readonly, retain) UITextField *usernameTextField;
@property (nonatomic, readonly, retain) UITextField *passwordTextField;
@property (nonatomic, readonly, retain) UITextField *confirmPasswordTextField;
@property (nonatomic, readonly, retain) UITextField *emailTextField;

@end

@implementation RegisterViewController

@synthesize usernameTextField = __usernameTextField, passwordTextField = __passwordTextField, confirmPasswordTextField = __confirmPasswordTextField, emailTextField = __emailTextField;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"Register";
	self.view.backgroundColor = BACKGROUND_COLOR;
}

- (IBAction)submitButtonPressed:(id)sender
{
	if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
	{
		[[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your password field and confirm password field must match. Please recheck your typing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSString *username = self.usernameTextField.text;
	NSString *password = self.passwordTextField.text;
	
	if (username == nil || [username isEqualToString:@""])
	{
		[[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	if (password == nil || [password isEqualToString:@""])
	{
		[[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	NSDictionary *userData = nil;
	if (self.emailTextField.text)
	{
		userData = [NSDictionary dictionaryWithObject:self.emailTextField.text forKey:@"email"];
	}
	[[PuzzleSDK sharedInstance] createUser:username password:password userData:userData onCompletion:^(PuzzleAPIResponse response, id data) {
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

- (void)dealloc
{
	[__usernameTextField release];
	__usernameTextField = nil;
	[__passwordTextField release];
	__passwordTextField = nil;
	[__confirmPasswordTextField release];
	__confirmPasswordTextField = nil;
	[__emailTextField release];
	__emailTextField = nil;
	
	[super dealloc];
}

@end
