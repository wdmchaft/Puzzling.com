//
//  CreateUserOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateUserOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"
#import "PuzzleCurrentUser.h"


#define USER_NAME @"username"
#define USER_DATA @"userData"

#define PASSWORD @"password"

@interface CreateUserOperation() {
    NSString* user_name;
    NSString* user_password;
    NSDictionary* user_data;
}
@property (nonatomic, retain, readwrite) NSString* userName;
@property (nonatomic, retain, readwrite) NSString* password;
@property (nonatomic, retain, readwrite) NSDictionary* userData;

@end

@implementation CreateUserOperation

@synthesize userName = user_name;
@synthesize password = user_password;
@synthesize userData = user_data;


-(id)initWithUserName:(NSString*)userName password:(NSString*)password userData:(NSDictionary*)data onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.userName = userName;
        self.password = password;
        self.userData = data;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.userName, USER_NAME, self.password, PASSWORD, self.userData, USER_DATA, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForCreateUser];
}

- (void)runCompletionBlock{
	NSDictionary *userData = [self.data objectFromJSONData];
	[PuzzleCurrentUser logout];
	PuzzleCurrentUser *currentUser = [[[PuzzleCurrentUser alloc] init] autorelease];
	currentUser.username = [userData objectForKey:@"username"];
	currentUser.userID = [userData objectForKey:@"user_id"];
	currentUser.authToken = [userData objectForKey:@"authToken"];
	currentUser.rating = [[userData objectForKey:@"rating"] doubleValue] + .5;
	currentUser.userData = [userData objectForKey:@"userData"];
	[currentUser save];
	
    self.onCompletion(self.response, [PuzzleCurrentUser currentUser]);
}

-(void) dealloc{
    [user_name release];
    [user_password release];
    [user_data release];
    [super dealloc];
}



@end
