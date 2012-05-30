//
//  GetAuthTokenForUserOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetAuthTokenForUserOperation.h"
#import "PuzzleCurrentUser.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"


#define USER_NAME @"username"
#define PASSWORD @"password"

@interface GetAuthTokenForUserOperation() {
    NSString* user_name;
    NSString* user_password;
}
@property (nonatomic, retain, readwrite) NSString* userName;
@property (nonatomic, retain, readwrite) NSString* password;

@end

@implementation GetAuthTokenForUserOperation

@synthesize userName = user_name;
@synthesize password = user_password;


-(id)initWithUserName:(NSString*)userName password:(NSString*)password onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.userName = userName;
        self.password = password;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"GET"];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetAuthTokenForUser:self.userName password:self.password];
}

- (void)runCompletionBlock{
	NSDictionary *userData = [self.data objectFromJSONData];
	[PuzzleCurrentUser logout];
	PuzzleCurrentUser *currentUser = [[[PuzzleCurrentUser alloc] init] autorelease];
	currentUser.username = [userData objectForKey:@"username"];
	currentUser.userID = [userData objectForKey:@"user_id"];
	currentUser.authToken = [userData objectForKey:@"authToken"];
	currentUser.userData = [((NSString *)[userData objectForKey:@"user_data"]) objectFromJSONString];
	NSLog(@"%@", currentUser.userData);
	[currentUser save];
	
    self.onCompletion(self.response, [PuzzleCurrentUser currentUser]);
}

-(void) dealloc{
    [user_name release];
	user_name = nil;
    [user_password release];
	user_password = nil;
	
    [super dealloc];
}


@end
