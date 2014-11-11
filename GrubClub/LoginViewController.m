//
//  LoginViewController.m
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "FLTableViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize currentUser;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_userPassword setDelegate:self];
    [_userName setDelegate:self];
    NSLog(@"LoginScreen currentUser: %@",self.currentUser.login);
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
    NSString *userLogin = _userName.text;
    NSString *userPassword = _userPassword.text;
    
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = userLogin;
    parameters.userPassword = userPassword;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        NSLog(@"hereeeeeeeeeeee");
        // Sign In to QuickBlox Chat
        QBUUser *current = [QBUUser user];
        current.login = userLogin;
        current.ID = session.userID; // your current user's ID
        NSLog(@"current ID: %lu",(unsigned long)session.userID);
        current.password = userPassword; // your current user's password
        
        // set Chat delegate
        [QBChat instance].delegate = self;
        
        // login to Chat
        [[QBChat instance] loginWithUser:current];
//        [self performSegueWithIdentifier:@"toMain" sender:self];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Login failed");
        NSString * error = [response.error description];
        NSLog(@"error is this: %@",error);
        UIAlertView *LoginFailed = [[UIAlertView alloc]initWithTitle:@"Incorrect Login" message:@"The username or password you entered was incorrect. Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [LoginFailed show];
    }];
    
    
}

- (void)chatDidLogin{
    NSLog(@"logged into chat successfully");
    NSLog(@"person logged in: %lu", (unsigned long)[[QBChat instance] currentUser].ID);
    NSLog(@"isloggedin: %d",[[QBChat instance] isLoggedIn]);
    NSLog(@"login succeeded now creating records");
    [self performSegueWithIdentifier:@"toMain" sender:self];
}
//prepare current user for the next screen?
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    [self.navigationController setNavigationBarHidden:NO];
//    if ([segue.identifier isEqualToString:@"toMain"]) {
//        FLTableViewController *vc = [segue destinationViewController];
//        vc.currentUser = self.currentUser;
//    }
//}
@end
