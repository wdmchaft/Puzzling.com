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


#define USER_NAME @"username"
#define PASSWORD @"password"

@interface CreateUserOperation() {
    NSString* user_name;
    NSString* user_password;
    NSDictionary* user_data;
}
@property (nonatomic, retain, readwrite) NSString* userName;
@property (nonatomic, retain, readwrite) NSString* password;
@property (nonatomic, retain, readwrite) NSDictionary* data;

@end

@implementation CreateUserOperation

@synthesize userName = user_name;
@synthesize password = user_password;
@synthesize data = user_data;


-(id)initWithUserName:(NSString*)userName password:(NSString*)password userData:(NSDictionary*)data onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.userName = userName;
        self.password = password;
        self.data = data;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.userName, USER_NAME, self.password, PASSWORD, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForCreateUser];
}



@end
