//
//  GetFlaggedPuzzlesOperation.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/26/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "GetFlaggedPuzzlesOperation.h"
#import "JSONKit.h"
#import "PuzzleModel.h"
#import "PuzzleAPIURLFactory.h"
#import "PuzzleParsingHelpers.h"


@implementation GetFlaggedPuzzlesOperation

- (NSURL *)url
{
	return [PuzzleAPIURLFactory urlForGetFlagged];
}

- (void)runCompletionBlock
{
	NSArray *flaggedData = [self.data objectFromJSONData];
	NSMutableArray *flaggedPuzzles = [NSMutableArray arrayWithCapacity:[flaggedData count]];
	for (NSDictionary *data in flaggedData)
	{
		PuzzleModel *puzzle = [PuzzleParsingHelpers parseDictionary:data];
		[flaggedPuzzles addObject:puzzle];
	}
	
self.onCompletion(self.response, flaggedPuzzles);
}

@end
