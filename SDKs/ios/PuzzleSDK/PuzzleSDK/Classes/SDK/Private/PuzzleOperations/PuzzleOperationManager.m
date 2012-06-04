//
//  PuzzleOperationManager.m
//  PuzzlingSDK
//
//  Created by Jonathan Tilley on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleOperationManager.h"
#import "CreateAppOperation.h"
#import "GetPuzzleOperation.h"
#import "CreatePuzzleOperation.h"
#import "GetPuzzleForUserOperation.h"
#import "TakePuzzleOperation.h"
#import "GetAuthTokenForUserOperation.h"
#import "DeleteUserOperation.h"
#import "CreateUserOperation.h"
#import "GetPuzzlesMadeByUserOperation.h"
#import "LeaderboardUsersOperation.h"
#import "AddCommentOperation.h"
#import "GetCommentsOperation.h"
#import "GetFlaggedPuzzlesOperation.h"
#import "FlagForRemovalOperation.h"
#import "DeletePuzzleOperation.h"
#import "DeflagPuzzleOperation.h"
#import "LikeDislikeOperation.h"
#import "LeaderboardPuzzlesOperation.h"


@interface PuzzleOperationManager() <NSURLConnectionDelegate> {
    NSOperationQueue *puzzle_queue;
}

@property (nonatomic, readwrite, retain) NSOperationQueue *queue;

@end

@implementation PuzzleOperationManager

@synthesize queue = puzzle_queue;

- (id)init {
    self = [super init];
    if (self) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
    }
    return self;
}

#pragma mark - App
-(void) createApp:(NSString *)name onCompletion:(PuzzleOnCompletionBlock)onCompletion{
    CreateAppOperation * operation = [[CreateAppOperation alloc] initWithName:name onCompletionBlock:onCompletion];
	[self.queue addOperation:operation];
	[operation release];
}

#pragma mark - Puzzles

- (void)getPuzzleForID:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetPuzzleOperation * operation = [[GetPuzzleOperation alloc] initWithPuzzleID:puzzleID onCompletionBlock:onCompletion delegate:self];
	[self.queue addOperation:operation];
	[operation release];
}

- (void)createPuzzleWithType:(NSString *)type name:(NSString *)name setupData:(NSDictionary *)setupData solutionData:(NSDictionary*)solutionData isUpdate:(PuzzleID *)puzzleID onCompletionBlock:(PuzzleOnCompletionBlock)block {
	CreatePuzzleOperation *op = [[CreatePuzzleOperation alloc] initWithType:type name:name setupData:setupData solutionData:solutionData puzzleType:type isUpdate:puzzleID onCompletionBlock:block];
	[self.queue addOperation:op];
	[op release];
}

- (void)getPuzzleForCurrentUserOnCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetPuzzleForUserOperation *op = [[GetPuzzleForUserOperation alloc] initWithOnCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)takePuzzle:(PuzzleID *)puzzleID score:(float)score rated:(BOOL)rated onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	TakePuzzleOperation *op = [[TakePuzzleOperation alloc] initWithPuzzleID:puzzleID score:score rated:rated onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)deletePuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	DeletePuzzleOperation *op = [[DeletePuzzleOperation alloc] initWithPuzzleID:puzzleID onCompletion:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

#pragma mark - Login

- (void)loginUserWithUsername:(NSString *)username password:(NSString *)password onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetAuthTokenForUserOperation *op = [[GetAuthTokenForUserOperation alloc] initWithUserName:username password:password onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)deleteUser:(NSString *)username onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	DeleteUserOperation *op = [[DeleteUserOperation alloc] initWithUserName:username onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)createUser:(NSString *)username password:(NSString *)password userData:(NSDictionary *)data onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	CreateUserOperation *op = [[CreateUserOperation alloc] initWithUserName:username password:password userData:data onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)getPuzzlesMadeByUser:(PuzzleID *)userID onCompletion:(PuzzleOnCompletionBlock)onCompletion {
	GetPuzzlesMadeByUserOperation *op = [[GetPuzzlesMadeByUserOperation alloc] initWithUserID:userID onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

#pragma mark - Leaderboard
- (void)getLeaderboardForUsersOnCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	LeaderboardUsersOperation *op = [[LeaderboardUsersOperation alloc] initWithOnCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)getLeaderboardForPuzzlesRatingOnCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	LeaderboardPuzzlesOperation *op = [[LeaderboardPuzzlesOperation alloc] initWithRating:YES onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)getLeaderboardForPuzzlesLikesOnCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	LeaderboardPuzzlesOperation *op = [[LeaderboardPuzzlesOperation alloc] initWithRating:NO onCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

#pragma mark - Comments

- (void)addComment:(NSString *)comment toPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	AddCommentOperation *op = [[AddCommentOperation alloc] initWithPuzzleID:puzzleID comment:comment onCompletion:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)getCommentsForPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	GetCommentsOperation *op = [[GetCommentsOperation alloc] initWithPuzzleID:puzzleID onCompletion:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

#pragma mark - Flag

- (void)getFlaggedPuzzlesOnCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	GetFlaggedPuzzlesOperation *op = [[GetFlaggedPuzzlesOperation alloc] initWithOnCompletionBlock:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)flagPuzzleForRemoval:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	FlagForRemovalOperation *op = [[FlagForRemovalOperation alloc] initWithPuzzleID:puzzleID onCompletion:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)deflagPuzzle:(PuzzleID *)puzzleID onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	DeflagPuzzleOperation *op = [[DeflagPuzzleOperation alloc] initWithPuzzleID:puzzleID onCompletion:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)likeDislikePuzzle:(PuzzleID *)puzzleID like:(BOOL)like onCompletion:(PuzzleOnCompletionBlock)onCompletion
{
	LikeDislikeOperation *op = [[LikeDislikeOperation alloc] initWithPuzzleID:puzzleID isLike:like onCompletion:onCompletion];
	[self.queue addOperation:op];
	[op release];
}

- (void)dealloc
{
    [puzzle_queue release];
    puzzle_queue = nil;
    
    [super dealloc];
}
@end
