//
//  FLTableViewController.h
//  GrubClub
//
//  Created by Surakij Areenukul on 10/21/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
@interface FLTableViewController : UITableViewController
- (IBAction)logOut:(id)sender;

@property PFUser *currentUser;
@end
