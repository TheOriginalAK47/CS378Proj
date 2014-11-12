//
//  FLTableViewController.h
//  GrubClub
//
//  Created by Surakij Areenukul on 11/10/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface FLTableViewController : UITableViewController
- (IBAction)addUsers:(id)sender;
@property NSMutableArray *friendsID;
@property NSMutableArray *friendsUsernames;
@property QBUUser *currentUser;

@end
