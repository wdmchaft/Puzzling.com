//
//  GetAuthTokenForUserOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetAuthTokenForUserOperation.h"

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
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.userName, USER_NAME, self.password, PASSWORD, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetAuthTokenForUser];
}



@end
