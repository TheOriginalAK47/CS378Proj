//
//  FriendRequestsViewController.h
//  GrubClub
//
//  Created by Surakij Areenukul on 11/9/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface FriendRequestsViewController : UITableViewController <QBChatDelegate>
@property QBUUser *searchedUser;
@property QBUUser *currentUser;
@end
