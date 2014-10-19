//
//  forgotPwViewController.m
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "forgotPwViewController.h"
#import "Parse/Parse.h"

@interface forgotPwViewController ()

@end

@implementation forgotPwViewController

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

- (IBAction)submitPwReset:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground: self.userEmail.text]; //password reset
    
    /*
     The flow for password reset is as follows:
     
     User requests that their password be reset by typing in their email.
     Parse sends an email to their address, with a special password reset link.
     User clicks on the reset link, and is directed to a special Parse page that will allow them type in a new password.
     User types in a new password. Their password has now been reset to a value they specify.
     
     */
}
@end
