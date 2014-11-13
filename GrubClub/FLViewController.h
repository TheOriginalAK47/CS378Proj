//
//  FLViewController.h
//  GrubClub
//
//  Created by Surakij Areenukul on 11/12/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
#import "MainViewController.h"

@interface FLViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *friendsList;
@property NSMutableArray *usernames;
@property QBUUser *currentUser;
@end
