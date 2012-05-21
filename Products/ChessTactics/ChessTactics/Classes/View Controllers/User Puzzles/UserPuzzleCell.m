//
//  UserPuzzleCell.m
//  ChessTactics
//
//  Created by Peter Livesey on 5/14/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "UserPuzzleCell.h"


#define RATING @"Rating: "
#define TAKEN @"Taken: "
#define LIKES @"Likes: "
#define DISLIKES @"Dislikes: "

@interface UserPuzzleCell() {
	IBOutlet UILabel *__nameLabel;
	IBOutlet UILabel *__ratingLabel;
	IBOutlet UILabel *__takenLabel;
	IBOutlet UILabel *__likesLabel;
	IBOutlet UILabel *__dislikesLabel;
}

@property (nonatomic, readonly, retain) UILabel *nameLabel;
@property (nonatomic, readonly, retain) UILabel *ratingLabel;
@property (nonatomic, readonly, retain) UILabel *takenLabel;
@property (nonatomic, readonly, retain) UILabel *likesLabel;
@property (nonatomic, readonly, retain) UILabel *dislikesLabel;

@end

@implementation UserPuzzleCell

@synthesize nameLabel = __nameLabel, ratingLabel = __ratingLabel, takenLabel = __takenLabel, likesLabel = __likesLabel, dislikesLabel = __dislikesLabel;

- (void)setName:(NSString *)name {
	self.nameLabel.text = name;
}

- (void)setRating:(int)rating {
	self.ratingLabel.text = [RATING stringByAppendingFormat:@"%d", rating];
}

- (void)setTaken:(int)taken {
	self.takenLabel.text = [TAKEN stringByAppendingFormat:@"%d", taken];
}

- (void)setLikes:(int)likes {
	self.likesLabel.text = [LIKES stringByAppendingFormat:@"%d", likes];
}

- (void)setDislikes:(int)dislikes {
	self.dislikesLabel.text = [DISLIKES stringByAppendingFormat:@"%d", dislikes];
}

- (void)dealloc {
	[__nameLabel release];
	__nameLabel = nil;
	[__ratingLabel release];
	__ratingLabel = nil;
	[__takenLabel release];
	__takenLabel = nil;
	[__likesLabel release];
	__likesLabel = nil;
	[__dislikesLabel release];
	__dislikesLabel = nil;
	
	[super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
