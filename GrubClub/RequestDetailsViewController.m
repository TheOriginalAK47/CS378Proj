//
//  RequestDetailsViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/12/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "RequestDetailsViewController.h"
#import <Quickblox/Quickblox.h>
#import "ChatService.h"
@interface RequestDetailsViewController ()

@end

@implementation RequestDetailsViewController
@synthesize userID;
@synthesize otherID;
@synthesize otherUsername;
@synthesize requests;
@synthesize requestsUsernames;
@synthesize index;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ChatService instance] setViewController:self];
    NSLog(@"requests array count in RequestDetail is: %d", requests.count);
    // Do any additional setup after loading the view.
    
    [QBRequest userWithID:userID successBlock:^(QBResponse *response, QBUUser *user) {
        // Successful response with user
        NSLog(@"retrieved user successfully");
        
        NSString *name = [NSString stringWithFormat:@"Name: %@",user.fullName];
        NSString *username = [NSString stringWithFormat:@"Username: %@",user.login];
        _nameLabel.text = name;
        _usernameLabel.text = username;
    } errorBlock:^(QBResponse *response) {
        // Handle error
    }];
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

- (IBAction)acceptPressed:(id)sender {
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    QBUUser *currentUser = [[QBChat instance] currentUser];
    [getRequest setObject:[NSNumber numberWithInt:currentUser.ID] forKey:@"user_id"];
    
    
    //get current user friend's list
    [QBRequest objectsWithClassName:@"FriendsList" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        
        //get the list itself
        QBCOCustomObject *list = [objects objectAtIndex:0];
        
        //add accepted person to friend current user friend list
        [list.fields setObject:otherID forKey:@"add_to_set[friendsList][]"];
        [list.fields setObject:otherUsername forKey:@"add_to_set[usernames][]"];
        [QBRequest updateObject:list successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
            NSLog(@"current user accepted friend request");
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    
    //get current user's friend requests list
    [QBRequest objectsWithClassName:@"FriendRequests" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        
        
        // response processing
        QBCOCustomObject *list = [objects objectAtIndex:0];
        
        //remove from list
        [requests removeObjectAtIndex:index];
        [requestsUsernames removeObjectAtIndex:index];
        
        //update friendRequests list
        [list.fields setObject:requests forKey:@"friendRequests"];
        [list.fields setObject:requestsUsernames forKey:@"usernames"];
        
        [QBRequest updateObject:list successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Add failed, Response error: %@", [response.error description]);
    }];
    
    
    //now finally get other users friends list
    [getRequest setObject:otherID forKey:@"user_id"];
    [QBRequest objectsWithClassName:@"FriendsList" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        
        //get the list itself
        QBCOCustomObject *list = [objects objectAtIndex:0];
        
        //add accepted person to friend current user friend list
        [list.fields setObject:[NSNumber numberWithLong:currentUser.ID] forKey:@"add_to_set[friendsList][]"];
        [list.fields setObject:currentUser.login forKey:@"add_to_set[usernames][]"];
        [QBRequest updateObject:list successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
            NSLog(@"current user accepted friend request");
             [self performSegueWithIdentifier:@"declined" sender:self];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    

    
    
}

- (IBAction)declinePressed:(id)sender {
    QBUUser *currentUser = [[QBChat instance] currentUser];
    NSLog(@"removed user at row: %d", (int)index);
    [requests removeObjectAtIndex:index];
    [requestsUsernames removeObjectAtIndex:index];
    
    
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSNumber numberWithLong:currentUser.ID] forKey:@"user_id"];
    
    
    //make request
    [QBRequest objectsWithClassName:@"FriendRequests" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        
        
        // response processing
        NSLog(@"add worked. objects in objects array: %lu", (unsigned long)objects.count);
        QBCOCustomObject *list = [objects objectAtIndex:0];
        
        [list.fields setObject:requests forKey:@"friendRequests"];
        [list.fields setObject:requestsUsernames forKey:@"usernames"];
        
        [QBRequest updateObject:list successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
            [self performSegueWithIdentifier:@"declined" sender:self];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Add failed, Response error: %@", [response.error description]);
    }];
}
@end
