//
//  PuzzleErrorHandler.m
//  PuzzleSDK
//
//  Created by Peter Livesey on 4/27/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "PuzzleErrorHandler.h"

@implementation PuzzleErrorHandler

+ (PuzzleAPIResponse)errorForString:(NSString *)error
{
	if ([error isEqualToString:@"wrong_password"]) {
		return PuzzleErrorInvalidPassword;
	} else if ([error isEqualToString:@"no_username_exists"]) {
		return PuzzleErrorUsernameNotFound;
	} else if ([error isEqualToString:@"user_exists"]) {
		return PuzzleErrorUsernameAlreadyExists;
	} else if ([error isEqualToString:@"no_such_user_exists"]) {
		return PuzzleErrorCannotFindUser;
	} else if ([error isEqualToString:@"invalid_authtoken"]) {
		return PuzzleErrorInvalidAuthtoken;
	} else if ([error isEqualToString:@"no_puzzles_to_return"]) {
		return PuzzleErrorNoPuzzlesToSuggest;
	} else if ([error isEqualToString:@"puzzle_doesnt_exist"]) {
		return PuzzleErrorPuzzleDoesntExist;
	} else if ([error isEqualToString:@"unknown_error"]) {
		return PuzzleErrorUnknown;
	} else if ([error isEqualToString:@"api_key_error"]) {
		return PuzzleErrorAPIKey;
	} else if ([error isEqualToString:@"no_such_operation"]) {
		return PuzzleErrorMalformedOperation;
	} else if ([error isEqualToString:@"missing_info"]) {
		return PuzzleErrorMalformedOperation;
	} else {
		return PuzzleErrorUnknown;
	}
}

+ (NSString *)messageForError:(PuzzleAPIResponse)error
{
	switch (error) {
		case PuzzleErrorUnknown:
			return @"Unknown error. Sorry.";
			
		case PuzzleErrorInvalidPassword:
			return @"Invalid password. Please try again.";
			
		case PuzzleErrorUsernameNotFound:
			return @"Username not found. Please check your spelling.";
			
		case PuzzleErrorUsernameAlreadyExists:
			return @"Username already exists. Please choose a different username.";
			
		case PuzzleErrorCannotFindUser:
			return @"Cannot find the username asked for. Please try the request again.";
			
		case PuzzleErrorInvalidAuthtoken:
			return @"Something went wrong with your login. Please logout and login again.";
			
		case PuzzleErrorInternalServer:
			return @"There was an internal server error. Sorry.";
			
		case PuzzleErrorNoPuzzlesToSuggest:
			return @"You've taken all the tactics we currently have. Why don't you make one of your own and check back later.";
			
		case PuzzleErrorPuzzleDoesntExist:
			return @"The puzzle your trying to view doens't exist in our database. Please try again.";
			
		case PuzzleErrorAPIKey:
			return @"Something is wrong with the way the app is communicating with the server. Please reinstall the app.";
			
		case PuzzleErrorMalformedOperation:
			return @"Sorry. You're getting this message because there is some bug in the app. Please contact the developer with the details of this error. Thank you.";
			
		case PuzzleErrorConnectionProblem:
			return @"Sorry. We're having problems connecting to the server. Please check your internet connection and try again. If the problem persists, please contact the developer as the server may be down.";
			
		case PuzzleErrorInternetProblem:
			return @"Sorry, we're having trouble connecting to the internet. Please check your internet connection and try again.";
		
		default:
			return @"Unknown error. Sorry.";
			break;
	}
}

+ (void)presentErrorForResponse:(PuzzleAPIResponse)error 
{
	[[[[UIAlertView alloc] initWithTitle:@"Error" message:[[self class] messageForError:error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

@end
