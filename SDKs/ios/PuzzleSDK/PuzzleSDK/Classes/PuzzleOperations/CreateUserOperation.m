//
//  CreateUserOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateUserOperation.h"


@interface CreateUserOperation() {
    NSString* user_name;
    NSString* user_password;
    NSDictionary* user_data;
}
@end

@implementation CreateUserOperation

-(id)initWithUserName:(NSString*)userName password:(NSString*)password userData:(NSDictionary*)data delegate:(id<PuzzleOperationDelegate>) delegate{
    self = [super init];
    if(self){
        user_name = userName;
        user_password = password;
        user_data = data;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForCreateUser];
}



@end
