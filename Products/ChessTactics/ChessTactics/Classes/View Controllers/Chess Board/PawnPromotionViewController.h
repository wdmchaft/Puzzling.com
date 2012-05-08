//
//  PawnPromotionViewController.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/6/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PawnPromotionDelegate;

@interface PawnPromotionViewController : UIViewController

@property (nonatomic, readwrite, assign) id<PawnPromotionDelegate> delegate;

@end

@protocol PawnPromotionDelegate <NSObject>

- (void)pawnPromotionViewController:(PawnPromotionViewController *)pawnPromotionVC didSelectClass:(Class)type;

@end
