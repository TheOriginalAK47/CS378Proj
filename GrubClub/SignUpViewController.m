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

-(BOOL) usernameTaken:(NSString *)username {
    PFQuery *usernameQuery = [PFUser query];
    [usernameQuery whereKey:@"username" equalTo:username]; // find all the women
    NSArray *usernames = [usernameQuery findObjects];
    if ([usernames count] > 0) {
        return YES;
    }
    return NO;
}

-(BOOL) emailTaken:(NSString *)email {
    PFQuery *emailQuery = [PFUser query];
    [emailQuery whereKey:@"email" equalTo:email]; // find all the women
    NSArray *emails = [emailQuery findObjects];
    if ([emails count] > 0) {
        return YES;
    }
    return NO;
}

- (IBAction)submitInformation:(id)sender {
//    PFUser *user = [PFUser user];
//    user.username = self.userName.text;

    QBUUser *user = [QBUUser user];
    user.login = self.userName.text;
    user.password = self.userPassword.text;
    user.email = self.userEmail.text;
    user.fullName = self.personalName.text;
    
    UIAlertView *SignupFailed = [[UIAlertView alloc]initWithTitle:@"Invalid Account Info" message:@"The email, username, or password you entered is not allowed." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    bool valid = YES;
    if (![self usernameValid:user.login]) {
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
    
    
    //TODO: username taken
//    if ([self usernameTaken:user.login]) {
//        UIAlertView *usernameTaken = [[UIAlertView alloc]initWithTitle:@"Account Name Taken" message:@"It looks like another user has already taken that username. Please try using another." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//        [usernameTaken show];
//        NSLog(@"Username already in Parse DB");
//        return;
//    }
//    
//    if ([self emailTaken:user.email]) {
//        UIAlertView *emailTaken = [[UIAlertView alloc]initWithTitle:@"Account with email exists" message:@"There is already an account registered with that email. Please use another." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//        [emailTaken show];
//        NSLog(@"Email already in Parse DB");
//        return;
//    }
    
    // Registration/sign up of User
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
        // Sign up was successful
        
        [self login];
        [self performSegueWithIdentifier:@"toSuccess" sender:self];
    } errorBlock:^(QBResponse *response) {
        // Handle error here
        NSString *errorString = [response.error description];
        //            // Show the errorString somewhere and let the user try again.
        NSLog(@"%@", errorString);
        
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
        QBCOPermissions *permissions = [QBCOPermissions permissions];
        permissions.updateAccess = QBCOPermissionsAccessOpen;
        permissions.readAccess = QBCOPermissionsAccessOwner;
        permissions.deleteAccess = QBCOPermissionsAccessOwner;
        
        object2.permissions = permissions;
        
        [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            NSLog(@"FriendsList made");
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        [QBRequest createObject:object2 successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // do something when object is successfully created on a server
            NSLog(@"FriendRequests List made");
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
        
        NSLog(@"Now logging out");
        [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
            // Successful logout
            NSLog(@"Logout successful");
        } errorBlock:^(QBResponse *response) {
            // Handle error
        }];
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
