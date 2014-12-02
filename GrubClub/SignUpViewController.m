//
//  SignUpViewController.m
//  GrubClub
//
//  Created by Ali Khan on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "SignUpViewController.h"
#import <Quickblox/Quickblox.h>

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
    NSRegularExpression *passwordRegex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9_-]{8,18}$" options:0 error:&error];
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
//    PFUser *user = [PFUser user];
//    user.username = self.userName.text;

    QBUUser *user = [QBUUser user];
    user.login = self.userName.text;
    user.password = self.userPassword.text;
    user.email = self.userEmail.text;
    user.fullName = self.personalName.text;
    NSString *invalid;
    
    bool valid = YES;
    if (![self usernameValid:user.login]) {
        NSLog(@"Bad username");
        invalid = @"Invalid username";
        valid = NO;
    } if (![self passwordValid:user.password]) {
        NSLog(@"Bad password");
        valid = NO;
        invalid = @"Invalid password";
    } if (![self emailValid:user.email]) {
        NSLog(@"Bad email");
        valid = NO;
        invalid = @"Invalid email";
    } if (![self personalNameValid:_personalName.text]) {
        NSLog(@"Bad personal name");
        valid = NO;
        invalid = @"Invalid name";
    }
    NSString *error =[NSString stringWithFormat:@"You have entered an %@",invalid];
    if (!valid) {
        UIAlertView *SignupFailed = [[UIAlertView alloc]initWithTitle:@"Invalid Account Info" message:error delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [SignupFailed show];
        NSLog(@"Invalid username, password, email, or personal name."); // Can change to provide more info later but for now this should work.
        return;
    }
    
    // Registration/sign up of User
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
        // Sign up was successful
        
        [self login];
    } errorBlock:^(QBResponse *response) {
        // Handle error here
            NSLog(@"%@", [response.error description]);
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Email or username already taken. Try another."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [errorAlert show];
    }];
    
}
- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        // Login succeeded
        NSLog(@"login succeeded now creating records");
        QBCOCustomObject *object = [QBCOCustomObject customObject];
        object.className = @"FriendsList"; // your Class name
        QBCOCustomObject *object2 = [QBCOCustomObject customObject];
        object2.className = @"FriendRequests"; // your Class name
        QBCOCustomObject *userSession = [QBCOCustomObject customObject];
        userSession.className = @"activeSession";
        
        QBCOPermissions *permissions = [QBCOPermissions permissions];
        permissions.updateAccess = QBCOPermissionsAccessOpen;
        permissions.readAccess = QBCOPermissionsAccessOpen;
        permissions.deleteAccess = QBCOPermissionsAccessOpen;
        
        object2.permissions = permissions;
        object.permissions = permissions;
        userSession.permissions = permissions;
        
        
        [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            NSLog(@"FriendsList made");
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        [QBRequest createObject:object2 successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // do something when object is successfully created on a server
            NSLog(@"FriendRequests List made");
            NSLog(@"Now logging out");
            [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
                // Successful logout
                NSLog(@"Logout successful");
            } errorBlock:^(QBResponse *response) {
                // Handle error
            }];
            [self performSegueWithIdentifier:@"toSuccess" sender:self];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
        [QBRequest createObject:userSession successBlock:^(QBResponse *response, QBCOCustomObject *userSession) {
            NSLog(@"UserSession token made");
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Failed to make token. Response error: %@", [response.error description]);
        }];
        
        
//        NSLog(@"Now logging out");
//        [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
//            // Successful logout
//            NSLog(@"Logout successful");
//        } errorBlock:^(QBResponse *response) {
//            // Handle error
//        }];
    };
}

- (QBRequestErrorBlock)errorBlock
{
    return ^(QBResponse *response) {
        // Handle error
        NSLog(@"login failed");
    };
}

- (void)login
{
    // Authenticate user
    [QBRequest logInWithUserLogin:_userName.text password:_userPassword.text
                     successBlock:[self successBlock] errorBlock:[self errorBlock]];
}
@end
