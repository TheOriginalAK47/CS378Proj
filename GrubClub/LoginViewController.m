//
//  LoginViewController.m
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_userPassword setDelegate:self];
    [_userName setDelegate:self];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    // Indicate we're done with the keyboard. Make it go away.
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonAction:(id)sender {

    [PFUser logInWithUsernameInBackground:self.userName.text password:self.userPassword.text block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
            
            //set currentUser to pass later maybe
            _currentUser = user;
//            NSLog(@"Current user: %@" , _currentUser.username);
            
            
            if (![[_currentUser objectForKey:@"emailVerified"] boolValue]) {
                // Refresh to make sure the user did not recently verify
//                [_currentUser fetch]; /*this causes a warning
                if (![[user objectForKey:@"emailVerified"] boolValue]) {
                    UIAlertView *emailUnverified = [[UIAlertView alloc]initWithTitle:@"Email Verification Failed" message:@"Please verify your email address." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [emailUnverified show];
//                    [self redirectWithMessage:@"You must verify your email address for cake"];
                    return;
                }
            }
            
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewController = [main instantiateViewControllerWithIdentifier:@"FriendListVC"];
            [self presentViewController:viewController animated:YES completion:nil];
            NSLog(@"User login successful");
        }
        else {
            // The login failed. Check error to see why.
            NSLog(@"Login failed");
            UIAlertView *LoginFailed = [[UIAlertView alloc]initWithTitle:@"Incorrect Login" message:@"The username or password you entered was incorrect. Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [LoginFailed show];
            
            
        }}];
    

}
@end
