//
//  SignUpViewController.h
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *personalName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
-(IBAction)submitInformation:(id)sender;
-(BOOL)personalNameValid:(NSString *)personalName;
-(BOOL)passwordValid:(NSString *)password;
-(BOOL)usernameValid:(NSString *)username;
-(BOOL)emailValid:(NSString *)email;

@end
