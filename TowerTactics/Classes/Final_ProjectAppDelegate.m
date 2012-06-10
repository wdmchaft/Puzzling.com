//
//  Final_ProjectAppDelegate.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/7/10.
//  Copyright Stanford 2010. All rights reserved.
//

#import "Final_ProjectAppDelegate.h"
#import "LoginViewController.h"
#import "IntroPageViewController.h"
#import "PuzzleCurrentUser.h"

@implementation Final_ProjectAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    viewController =  [[IntroPageViewController alloc] initWithNibName:@"IntroPageViewController" bundle:[NSBundle mainBundle]];
    
    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    
    if(![PuzzleCurrentUser currentUser]){
        LoginViewController * login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        
        login.introViewController = viewController;
        
        [viewController presentModalViewController:login animated:YES];
    }
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
