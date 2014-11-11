//
//  forgotPwViewController.m
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "forgotPwViewController.h"

@interface forgotPwViewController ()

@end

@implementation forgotPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_userEmail setDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    // Indicate we're done with the keyboard. Make it go away.
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL) emailValid:(NSString *)email {
    NSError *error = NULL;
    NSRegularExpression *emailRegex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:0 error:&error];
    // Check error here... (maybe the regex pattern was malformed)
    NSUInteger numberOfMatches = [emailRegex numberOfMatchesInString:email options:0
                                                               range:NSMakeRange(0, [email length])]; // Check full string
    if (numberOfMatches < 1) {
        return NO;
    }
    else {
        return YES;
    }
}

- (IBAction)submitPwReset:(id)sender {
    
    NSString *email = self.userEmail.text;
    if (![self emailValid:email]) {
        UIAlertView *invalidEmail = [[UIAlertView alloc]initWithTitle:@"Invalid Email" message:@"The email you provided isn't a proper email address." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [invalidEmail show];
        NSLog(@"Provided incorrect email address.");
        return;
    }
    [QBRequest resetUserPasswordWithEmail:email successBlock:^(QBResponse *response) {
        // Reset was successful
        [self performSegueWithIdentifier:@"retrieveSuccess" sender:self];
    } errorBlock:^(QBResponse *response) {
        // Error
        UIAlertView *SignupFailed = [[UIAlertView alloc]initWithTitle:@"Invalid Email" message:@"The email was not found." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [SignupFailed show];
        return;
    }];
    
    /*
     The flow for password reset is as follows:
     
     User requests that their password be reset by typing in their email.
     Parse sends an email to their address, with a special password reset link.
     User clicks on the reset link, and is directed to a special Parse page that will allow them type in a new password.
     User types in a new password. Their password has now been reset to a value they specify.
     
     */
}
@end
