//
//  FriendsListCell.m
//  GrubClub
//
//  Created by Andrew Kogler on 12/1/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "FriendsListCell.h"

@implementation FriendsListCell
@synthesize contactStatus = _contactStatus;
@synthesize contactName = _contactName;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
