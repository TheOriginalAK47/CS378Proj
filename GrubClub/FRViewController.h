//
//  FRViewController.h
//  GrubClub
//
//  Created by Surakij Areenukul on 11/10/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface FRViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *requests;
@property NSMutableArray *requestsUsernames;
- (IBAction)cancelPressed:(id)sender;
@property QBUUser *searchedUser;
@property QBUUser *currentUser;

@end
