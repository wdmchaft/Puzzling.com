//
//  UserPuzzleCell.h
//  ChessTactics
//
//  Created by Peter Livesey on 5/14/12.
//  Copyright (c) 2012 Lockwood Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPuzzleCell : UITableViewCell

- (void)setName:(NSString *)name;
- (void)setRating:(int)rating;
- (void)setTaken:(int)taken;
- (void)setLikes:(int)likes;
- (void)setDislikes:(int)dislikes;

@end
