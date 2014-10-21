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
    [_personalName setDelegate:self];
    [_userEmail setDelegate:self];
    [_userName setDelegate:self];
    [_userPassword setDelegate:self];
    
    
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

-(BOOL) usernameValid:(NSString *)username {
    NSError *error = NULL;
    NSRegularExpression *usernameRegex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9_-]{4,16}$" options:0 error:&error];
    NSUInteger numberOfMatches = [usernameRegex numberOfMatchesInString:username options:0
                                  range:NSMakeRange(0, [username length])]; // Check full string
    if (numberOfMatches < 1) {
        return NO;
    }
    else {
        return YES;
    }
}

-(BOOL) passwordValid:(NSString *)password {
    NSError *error = NULL;
    NSRegularExpression *passwordRegex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9_-]{6,18}$" options:0 error:&error];
    NSUInteger numberOfMatches = [passwordRegex numberOfMatchesInString:password options:0
                                  range:NSMakeRange(0, [password length])]; // Check full string
    if (numberOfMatches < 1) {
        return NO;
    }
    else {
        return YES;
    }
}

-(BOOL) personalNameValid:(NSString *)personalName {
    NSError *error = NULL;
    NSRegularExpression *personalNameRegex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z .'-]+$" options:0 error:&error];
    NSUInteger numberOfMatches = [personalNameRegex numberOfMatchesInString:personalName options:0
                                  range:NSMakeRange(0, [personalName length])]; // Check full string
    if (numberOfMatches < 1) {
        return NO;
    }
    else {
        return YES;
    }
}

- (IBAction)submitInformation:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.userName.text;
    user.password = self.userPassword.text;
    user.email = self.userEmail.text;
    
    UIAlertView *SignupFailed = [[UIAlertView alloc]initWithTitle:@"Invalid Account Info" message:@"The email, username, or password you entered is not allowed." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    bool valid = YES;
    if (![self usernameValid:user.username]) {
        NSLog(@"Bad username");
        valid = NO;
    } if (![self passwordValid:user.password]) {
        NSLog(@"Bad password");
        valid = NO;
    } if (![self emailValid:user.email]) {
        NSLog(@"Bad email");
        valid = NO;
    } if (![self personalNameValid:_personalName.text]) {
        NSLog(@"Bad personal name");
        valid = NO;
    }
    if (!valid) {
        [SignupFailed show];
        NSLog(@"Invalid username, password, email, or personal name."); // Can change to provide more info later but for now this should work.
        return;
    }
    
    /*
    if ([self usernameTaken:user.username]) {
        
    }
    
    if ([self emailTaken:user.email]) {
        
    }
    */
    
    // other fields can be set just like with PFObject
    user[@"personalName"] = self.personalName.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"Submitted user sign up info to parse successfully");
            
            //so basically all you do is call this and the identifier is what you named the segue, dont do
            //specific button to view controller
            [self performSegueWithIdentifier:@"toSuccess" sender:self];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(errorString);
        }
    }];
    
}
@end
