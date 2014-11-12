//
//  AddDetailsViewController.h
//  GrubClub
//
//  Created by Surakij Areenukul on 11/9/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface AddDetailsViewController : UIViewController
@property QBUUser* user;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
- (IBAction)addPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;


@end
