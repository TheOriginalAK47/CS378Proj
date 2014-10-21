//
//  forgotPwViewController.h
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgotPwViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
- (IBAction)submitPwReset:(id)sender;

@end
