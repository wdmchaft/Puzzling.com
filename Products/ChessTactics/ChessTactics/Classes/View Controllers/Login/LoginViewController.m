//
//  LoginViewController.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/20/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PuzzleSDK.h"
#import "PuzzleErrorHandler.h"


@interface LoginViewController () {
	IBOutlet UITextField *__usernameTextField;
	IBOutlet UITextField *__passwordTextField;
}

@property (nonatomic, readonly, retain) UITextField *usernameTextField;
@property (nonatomic, readonly, retain) UITextField *passwordTextField;

- (void)registerButtonPressed;
- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation LoginViewController

@synthesize usernameTextField = __usernameTextField, passwordTextField = __passwordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title = @"Chess Tactics";
	
	UIBarButtonItem *registerButton = [[[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleBordered target:self action:@selector(registerButtonPressed)] autorelease];
	self.navigationItem.rightBarButtonItem = registerButton;
}

- (void)dealloc
{
	[__usernameTextField release];
	__usernameTextField = nil;
	[__passwordTextField release];
	__passwordTextField = nil;
	
	[super dealloc];
}

- (void)registerButtonPressed
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

@end
