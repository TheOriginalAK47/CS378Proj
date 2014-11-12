//
//  RequestDetailsViewController.h
//  GrubClub
//
//  Created by Surakij Areenukul on 11/12/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface RequestDetailsViewController : UIViewController
@property int userID;
@property NSString* otherUsername;
@property NSNumber* otherID;

@property NSNumber *selectedIndex;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
- (IBAction)acceptPressed:(id)sender;
- (IBAction)declinePressed:(id)sender;

@end
