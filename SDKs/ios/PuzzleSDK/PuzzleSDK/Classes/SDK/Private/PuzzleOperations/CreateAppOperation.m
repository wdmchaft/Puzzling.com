//
//  CreateAppOperation.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/4/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "CreateAppOperation.h"

#import "PuzzleAPIURLFactory.h"
#import "JSONKit.h"
#import "PuzzleCurrentUser.h"

#define NAME @"name"

@interface CreateAppOperation() {

}
@property (nonatomic, retain, readwrite) NSString* name;

@end

@implementation CreateAppOperation

@synthesize name;


-(id)initWithName:(NSString*)name onCompletionBlock:(PuzzleOnCompletionBlock)block{
    self = [super initWithOnCompletionBlock:block];
    if(self){
        self.name = name;
    }
    return self;
}

- (NSMutableURLRequest *)httpRequest {
    NSMutableURLRequest* request = [super httpRequest];
	[request setHTTPMethod:@"POST"];
    NSData* jsonData = [[NSDictionary dictionaryWithObjectsAndKeys:self.name, NAME, nil] JSONData];
    [request setHTTPBody: jsonData];
    return request;
}

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForCreateApp];
}

- (void)runCompletionBlock{
	
    self.onCompletion(self.response, [self.data objectFromJSONData]);
}



@end
