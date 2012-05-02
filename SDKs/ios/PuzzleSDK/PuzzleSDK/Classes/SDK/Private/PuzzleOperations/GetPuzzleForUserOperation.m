//
//  GetPuzzleForUser.m
//  PuzzleSDK
//
//  Created by Jonathan Tilley on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPuzzleForUserOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"


#define AUTHTOKEN @"authtoken"

@interface GetPuzzleForUserOperation() {
    NSString* p_authToken;
}
@property (nonatomic,retain,readwrite) NSString* authToken;
@end

@implementation GetPuzzleForUserOperation

@synthesize authToken = p_authToken;

-(id)initWithAuthToken:(NSString*)authToken onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.authToken = authToken;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"GET"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.authToken, AUTHTOKEN,nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForGetPuzzleForUser];
}

-(void) dealloc{
    [p_authToken release];
    [super dealloc];
}

@end
