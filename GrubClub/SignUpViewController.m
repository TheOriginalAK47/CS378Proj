//
//  SignUpViewController.m
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)submitInformation:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.userName.text;
    user.password = self.userPassword.text;
    user.email = self.userEmail.text;
    
    // other fields can be set just like with PFObject
    user[@"personalName"] = self.personalName.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"Submitted user sign up info to parse successfully");
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(errorString);
        }
    }];
}
@end
