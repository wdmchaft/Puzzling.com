//
//  LeaderboardUsersOperation.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/23/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import "LeaderboardUsersOperation.h"
#import "PuzzleAPIURLFactory.h"
#import "PuzzleUser.h"
#import "JSONKit.h"


@implementation LeaderboardUsersOperation

- (NSURL *)url {
    return [PuzzleAPIURLFactory urlForUserLeaderboard];
}

- (void)runCompletionBlock{
    NSMutableArray *users = [NSMutableArray array];
    
    NSArray* data = [self.data objectFromJSONData];
    for (NSDictionary *userData in data)
	{
		PuzzleUser *user = [[[PuzzleUser alloc] init] autorelease];
		user.username = [userData objectForKey:@"username"];
		user.userID = [userData objectForKey:@"user_id"];
		user.rating = [[userData objectForKey:@"rating"] doubleValue] + .5;
		user.userData = [userData objectForKey:@"userData"];
		[users addObject:user];
	}
	
    self.onCompletion(self.response, users); 
}

@end
