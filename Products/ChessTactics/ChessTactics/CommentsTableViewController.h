//
//  RootViewController.h
//  SMS Bubbles
//
//  Created by Cedric Vandendriessche on 17/07/10.
//  Copyright FreshCreations 2010. All rights reserved.
//

@interface CommentsTableViewController : UIViewController {
	IBOutlet UITableView *tbl;
	IBOutlet UITextField *field;
	IBOutlet UIToolbar *toolbar;
	NSMutableArray *messages;
}

- (IBAction)add;

@property (nonatomic, retain) UITableView *tbl;
@property (nonatomic, retain) UITextField *field;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) NSMutableArray *messages;

@end
