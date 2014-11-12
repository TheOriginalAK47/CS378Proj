//
//  LoginViewController.h
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, QBChatDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
- (IBAction)loginButtonAction:(id)sender;
@property QBUUser *currentUser; //would be used as a way to track session

@end
