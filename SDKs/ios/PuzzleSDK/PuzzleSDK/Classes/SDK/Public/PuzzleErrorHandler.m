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
	} else {
		return PuzzleErrorUnknown;
	}
}

+ (NSString *)messageForError:(PuzzleAPIResponse)error
{
	switch (error) {
		case PuzzleErrorUnknown:
			return @"Unknown error. Sorry.";
			break;
			
		case PuzzleErrorInvalidPassword:
			return @"Invalid password. Please try again.";
			break;
			
		case PuzzleErrorUsernameNotFound:
			return @"Username not found. Please check your spelling.";
			break;
			
		case PuzzleErrorUsernameAlreadyExists:
			return @"Username already exists. Please choose a different username.";
			break;
			
		case PuzzleErrorCannotFindUser:
			return @"Cannot find the username asked for. Please try the request again.";
			break;
			
		case PuzzleErrorInvalidAuthtoken:
			return @"Something went wrong with your login. Please logout and login again.";
			break;
			
		case PuzzleErrorInternalServer:
			return @"There was an internal server error. Sorry.";
			break;
			
		case PuzzleErrorNoPuzzlesToSuggest:
			return @"You've taken all the tactics we currently have. Why don't you make one of your own and check back later.";
			break;
			
		case PuzzleErrorPuzzleDoesntExist:
			return @"The puzzle your trying to view doens't exist in our database. Please try again.";
			break;
			
		case PuzzleErrorAPIKey:
			return @"Something is wrong with the way the app is communicating with the server. Please reinstall the app.";
			break;
			
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
