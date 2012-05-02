//
//  DeleteUserOperation.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeleteUserOperation.h"

#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"


#define USER_NAME @"username"

@interface DeleteUserOperation() {
    NSString* user_name;
}
@property (nonatomic, retain, readwrite) NSString* userName;

@end

@implementation DeleteUserOperation

@synthesize userName = user_name;


-(id)initWithUserName:(NSString*)userName onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.userName = userName;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"DELETE"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.userName, USER_NAME, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForDeleteUser];
}


-(void) dealloc{
    [user_name release];
    [super dealloc];
}


@end
