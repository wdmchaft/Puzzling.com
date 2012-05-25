//
//  RootViewController.h
//  SMS Bubbles
//
//  Created by Cedric Vandendriessche on 17/07/10.
//  Copyright FreshCreations 2010. All rights reserved.
//

#import "PuzzleSDK.h"


@interface CommentsTableViewController : UIViewController {
	IBOutlet UITableView *tbl;
	IBOutlet UITextField *field;
	IBOutlet UIToolbar *toolbar;
	NSArray *messages;
}

- (IBAction)add;

@property (nonatomic, readwrite, retain) PuzzleID *puzzleID;

@property (nonatomic, retain) UITableView *tbl;
@property (nonatomic, retain) UITextField *field;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) NSArray *messages;

@end
