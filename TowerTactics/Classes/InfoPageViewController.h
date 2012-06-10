//
//  InfoPageViewController.h
//  Final Project
//
//  Created by nadiafx on 10/03/16.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroPageViewController;


@interface InfoPageViewController : UIViewController {
	IBOutlet UIButton *backButton;
	IntroPageViewController *introPage;
}

-(IBAction)goBack;

@property (nonatomic, retain) IntroPageViewController *introPage;

@end
