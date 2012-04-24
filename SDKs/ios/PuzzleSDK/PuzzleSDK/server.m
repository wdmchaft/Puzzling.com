//
//  server.m
//  eggaduppa
//
//  Created by Jonathan Tilley on 04/02/11.
//  Copyright 2011 Fresh Cookies LLC. All rights reserved.
//

#import "server.h"
#define IP @"ec2-184-169-151-249.us-west-1.compute.amazonaws.com"
#define LOG 0


#import <CommonCrypto/CommonDigest.h>




@implementation server


//OLD example of saving data to lasting storage for an app, could be useful
+ (void) saveToPList:(NSString *)UUID{
	NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:UUID,@"UUID",nil];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *thePList = [documentsDirectory stringByAppendingPathComponent:@"UserData.plist"];
	[dict writeToFile:thePList atomically:NO];
}


+ (NSString *) pullUserKey{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *thePList = [documentsDirectory stringByAppendingPathComponent:@"UserData.plist"];
	
	NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:thePList];
	return [dic valueForKey:@"UUID"];
}
//




+ (void) request:(NSString *)json method:(NSString*)method url:(NSString *)url delegate:(id)delegate{
    if(delegate)
        if(LOG)NSLog(@"connection started, delegate is %@",[delegate class]);
    if(LOG)NSLog(@"posting %@",json);
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP, url]]];
    if(LOG)NSLog(@"%@%@",IP, url);
	NSString *msgLength = [NSString stringWithFormat:@"%d", [json length]];
	[request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:method];
	[request setHTTPBody: [json dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:YES];
}


//=============================================
/**
 Delegate Methods for NSURLConnection
 **/
/*
NSMutableData * data;

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    NSLog(@"data");
    if (data==nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	NSLog(@"connectiondidfinishloading");
    
    [theConnection release];
    theConnection =nil;
    parser * xmlparser = [[parser alloc] init];
    [xmlparser parseData:data parseError:nil];
    
	NSMutableDictionary * dict = [xmlparser getDict];
    if([dict objectForKey:@"error"])
        [self message: [dict objectForKey:@"error"]?[dict objectForKey:@"error"]:@"Unable to connect to eggaduppa's servers.  Make sure your internet connection is working."];
    else if ([@"true" isEqualToString:[dict valueForKey:@"hasAccess"]]) {
        self.dictionary = [server roundInfoFromDictionary:dict];
        [self presentNewRound];
    }else if(![dict valueForKey:@"roundNumber"]){
        //[self startRoundCheck:[dict valueForKey:@"message"] result:[dict valueForKey:@"result"]];
        [self message: @"Unable to connect to eggaduppa's servers.  Make sure your internet connection is working."];
    }else{
        //[self alertView];
        [self message: @"Looks like your version of eggaduppa is outdated.  Please update to the newest version to keep playing."];
    }
    
    [xmlparser release];
    [data release];
    data = nil;
    
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error 
{ 
	// release the connection, and the data object
	[theConnection release]; 
	// receivedData is declared as a method instance elsewhere 
	[data release]; 
	// inform the user 
	NSLog(@"Connection failed! Error - %@ %@", 
		  [error localizedDescription], 
		  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]); 
    [self error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)respons {
	NSLog(@"%@",respons);
}
*/
/**
 End Delegate
 **/
//=====================================================

@end
