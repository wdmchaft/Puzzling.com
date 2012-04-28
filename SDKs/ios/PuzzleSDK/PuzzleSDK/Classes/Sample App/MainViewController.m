//
//  MainViewController.m
//  PuzzleSDK
//
//  Created by Peter Livesey on 4/23/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "MainViewController.h"
#import "PuzzleSDK.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (IBAction)getPuzzle:(id)sender {
	[[PuzzleSDK sharedInstance] getPuzzle:@"4f9204c648a71e7312000003" onCompletion:^(PuzzleRequestStatus status, id data) {
		NSLog(@"Status: %d", status);
		NSLog(@"Data: %@", data);
	}];
}
@end
