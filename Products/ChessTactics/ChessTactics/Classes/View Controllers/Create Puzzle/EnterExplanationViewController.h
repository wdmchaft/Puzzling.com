//
//  EnterExplanationViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/18/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnterExplanationViewControllerDelegate;

@interface EnterExplanationViewController : UIViewController

@property (nonatomic, readwrite, assign) id<EnterExplanationViewControllerDelegate> delegate;

@end

@protocol EnterExplanationViewControllerDelegate <NSObject>

- (void)enterExplanationViewController:(EnterExplanationViewController *)vc didEnterExplanation:(NSString *)explanation;

@end